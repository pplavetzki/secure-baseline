KUBE_PATH ?= ${KUBECONFIG}
LOCATION ?= ${REGION}

TF_VERSION ?= 1.0.10

SECRETS ?= .coe-env

TF_DIR ?= ${CURRENT_DIR}/${TFDIR}

default:
	@echo ${KUBE_PATH}

tf-install:
	wget https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip -P /tmp/terraform_${TF_VERSION}
	echo 'Installing version: ${TF_VERSION} of Terraform'
	unzip /tmp/terraform_${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip -d /tmp/terraform_${TF_VERSION}
	sudo mv /tmp/terraform_${TF_VERSION}/terraform /usr/local/bin/
	terraform -v

tf-init:
	@cd ${TF_DIR} && terraform init -backend-config="storage_account_name=${STORAGEACCOUNTNAME}" \
			-backend-config="container_name=${CONTAINERNAME}" \
			-backend-config="access_key=${ACCESS_KEY}"

tf-plan:
	@cd ${TF_DIR} && terraform plan -out terraform.tfstate -input=false \
			-var-file=${OVERRIDES}

tf-apply:
	@cd ${TF_DIR} && terraform apply --auto-approve terraform.tfstate

encrypt:
	gpg --symmetric --cipher-algo AES256 ${SECRETS}

decrypt:
	gpg --quiet --batch --yes --decrypt --passphrase="${GPG_PASSPHRASE}" --output /tmp/${SECRETS} ${SECRETS}.gpg

az-login:
	@echo "Logging into Azure"
	@az login --service-principal -u $(APPLICATION_ID) -p ${SP_PASSWORD} --tenant ${TENANT} > /dev/null

aks-credentials: az-login tf-init
	@echo "retrieving the credentials to aks"
	./scripts/common/aks-creds.sh ${TF_DIR} ${KUBE_PATH}
	@echo "testing config..."
	@kubectl get nodes --kubeconfig=${KUBE_PATH}

arc-install: guard-CLUSTER_NAME guard-RESOURCE_GROUP guard-KUBE_PATH guard-LOCATION
	az connectedk8s connect --name ${CLUSTER_NAME} --resource-group ${RESOURCE_GROUP} --kube-config ${KUBE_PATH} --location ${LOCATION}

arc-delete: guard-CLUSTER_NAME guard-RESOURCE_GROUP guard-KUBE_PATH guard-LOCATION
	az connectedk8s delete --name ${CLUSTER_NAME} --resource-group ${RESOURCE_GROUP} --kube-config ${KUBE_PATH} --location ${LOCATION}

guard-%:
	@ if [ "${${*}}" = "" ]; then \
		echo "Environment variable $* not set"; \
		exit 1; \
	fi

.PHONY: arc-install arc-delete encrypt decrypt az-login tf-install tf-init tf-plan tf-apply aks-credentials


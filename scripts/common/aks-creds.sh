#!/bin/bash

TF_DIR=$1
KUBE_PATH=$2

cd $TF_DIR

AKS_NAME=$(terraform output -json | jq -r '.aks_name.value')
AKS_RG=$(terraform output -json | jq -r '.aks_rg.value')

az aks get-credentials -g $AKS_RG -n $AKS_NAME -a -f $KUBE_PATH > /dev/null

echo "AKS Creds written out to" $KUBE_PATH
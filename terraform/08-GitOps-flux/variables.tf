#############
# VARIABLES #
#############

variable "state_sa_name" {}

variable "container_name" {}

variable "access_key" {}

variable "kube_path" {}

variable "target_path" {
  type        = string
  default     = "staging-cluster"
  description = "flux install target path"
}

variable "github_owner" {}
variable "github_token" {}

variable "github_org" {}

variable "repository_name" {}

variable "repository_visibility" {}

variable "branch" {}

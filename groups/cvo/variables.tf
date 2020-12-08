
# ------------------------------------------------------------------------------
# AWS Variables
# ------------------------------------------------------------------------------
variable "account" {
  type        = string
  description = "The shorthand for the AWS account"
}

variable "aws_account" {
  type        = string
  description = "The AWS account in which resources will be administered"
}

variable "aws_region" {
  type        = string
  description = "The AWS region in which resources will be administered"
}

variable "region" {
  type        = string
  description = "The shorthand for the AWS region"
}

variable "vault_username" {
  type        = string
  description = "Username for connecting to Vault"
}

variable "vault_password" {
  type        = string
  description = "Password for connecting to Vault"
}

# ------------------------------------------------------------------------------
# NetApp Cloud Volumes Variables
# ------------------------------------------------------------------------------
variable "cvo_cluster_name" {
  type        = string
  description = "Name for the resources table being created"
}

variable "cvo_cluster_floating_ips" {
  type        = list(string)
  default     = [null, null, null, null]
  description = "List of Floating IPs to use if HA mode is set to 'FloatingIP'. If provided, should be of length 4 and contain 4 IP addresses outside of the VPC range."
  validation {
    condition     = length(var.cluster_floating_ips) == 4
    error_message = "Invalid input for cluster_floating_ips, requires list with 4 entries."
  }
}

variable "cvo_mediator_key_pair_name" {
  type        = string
  default     = null
  description = "The key pair name for the mediator instance."
}

variable "cvo_svm_password" {
  type        = string
  description = "The admin password for Cloud Volumes ONTAP."
}


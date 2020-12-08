
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
# NetApp Cloud Manager Variables
# ------------------------------------------------------------------------------
variable "cloud_manager_instance_type" {
  type        = string
  description = "instance type to be used for the NetApp Cloud Manager EC2 instance"
}

variable "cloud_manager_company_name" {
  type        = string
  description = "Company name string to be passed to NetApp module for naming and setup of Cloud Manager"
}

variable "cloud_manager_set_public_ip" {
  type        = string
  description = "Set a public IP on the NetApp Cloud Manager instance"
  default     = false
}

variable "cloud_manager_netapp_account_id" {
  type        = string
  description = "account Id as provided by NetApp Cloud Manager Portal to connect to the hosted Cloud Manager service"
}

variable "cloud_manager_ingress_ports" {
  description = "List object containg protocol, port and optional to_port"
}

variable "cloud_manager_egress_ports" {
  description = "List object containg protocol, port and optional to_port"
}

variable "cloud_manager_key_pair_name" {
  description = "Name of an existing key pair that should be used to create the Cloud Manager connector"
}
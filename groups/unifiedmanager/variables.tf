
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

variable "application" {
  type        = string
  description = "Name for the application being deployed"
}

# ------------------------------------------------------------------------------
# NetApp Unified Manager Variables
# ------------------------------------------------------------------------------
variable "unified_manager_instance_type" {
  type        = string
  description = "instance type to be used for the NetApp Unified Manager EC2 instance"
}

variable "unified_manager_company_name" {
  type        = string
  description = "Company name string to be passed to NetApp module for naming and setup of Unified Manager"
}

variable "ami_name" {
  type        = string
  default     = "centos7-base-*"
  description = "Name of the AMI to use for the Unified Manager Server"
}
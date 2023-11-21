# AWS variables
variable "aws_account" {
  type        = string
  description = "Name of the AWS account"
}

variable "aws_region" {
  type        = string
  description = "The AWS region to deploy in to"
  default     = "eu-west-2"
}

# Deployment variables
variable "application" {
  type        = string
  description = "Name of the application being deployed"
  default     = "snapcenter"
}

variable "service" {
  type        = string
  description = "Name of the service"
  default     = "netapp"
}

# EC2 variables
variable "admin_prefix_list_name" {
  type        = string
  description = "Name of the admin prefix list to lookup"
  default     = "administration-cidr-ranges"
}

variable "ami_id" {
  type        = string
  description = "ID for the base AMI used to deploy the instance"
}

variable "ebs_optimized" {
  type        = bool
  description = "Optimize the instance for EBS"
  default     = true
}

variable "get_password_data" {
  type        = bool
  description = "Defines whether to wait to retrieve the encrypted Windows password (true/false)"
  default     = true
}

variable "instance_type" {
  type        = string
  description = "Instance type for the snapcenter instance"
  default     = "t3.xlarge"
}

variable "monitoring" {
  type        = bool
  description = "Whether or not to enable enhanced moniotoring (true/false)"
  default     = true
}

variable "subnet_name" {
  type        = string
  description = "Name of the subnet to deploy the instance into"
}

# Azure AD security group variables

variable "azure_ad_ingress_tcp_udp" {
  type        = list(any)
  description = "A list of ports for Azure AD access UDP & TCP"
  default     = []
}

variable "azure_ad_ingress_tcp" {
  type        = list(any)
  description = "A list of ports for Azure AD access TCP"
  default     = []
}

variable "azure_ad_ingress_udp" {
  type        = list(any)
  description = "A list of ports for Azure AD access UDP"
  default     = []
}

variable "azure_ad_cidrs" {
  type        = list(any)
  description = "A list of cirdr blocks for azure AD access"
  default     = []
}

variable "Azure_ad_ingress_port_ranges_tcp_udp" {
  type        = list(any)
  description = "A list of ports, protocols and cirdr blocks for azure AD access"
  default     = []
}

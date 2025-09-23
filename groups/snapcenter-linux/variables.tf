variable "aws_account" {
  type        = string
  description = "The name of the AWS account in which resources will be provisioned."
}

variable "aws_region" {
  type        = string
  description = "The AWS region in which resources will be created."
}

variable "environment" {
  type        = string
  description = "The environment name to be used when provisioning AWS resources."
}

variable "ami_version_pattern" {
  type        = string
  description = "The pattern to use when filtering for AMI version by name."
  default     = "*"
}

variable "instance_count" {
  type        = number
  description = "The number EC2 instances to create."
  default     = 1
}

variable "instance_type" {
  type        = string
  description = "The EC2 instance type."
  default     = "t3.xlarge"
}

variable "root_volume_size" {
  type        = number
  description = "The size of the root volume in gibibytes (GiB)."
  default     = 100
}

variable "encrypt_root_block_device" {
  default     = true
  description = "Defines whether the EBS volume should be encrypted"
  type        = bool
}

variable "root_block_device_iops" {
  default     = 3000
  description = "The required IOPS on the EBS volume"
  type        = number
}

variable "root_block_device_throughput" {
  default     = 125
  description = "The required EBS volume throughput in MiB/s"
  type        = number
}

variable "root_block_device_volume_type" {
  default     = "gp3"
  description = "The type of EBS volume to provision"
  type        = string
}

variable "service" {
  type        = string
  description = "The service name to be used when provisioning AWS resources."
  default     = "netapp"
}

variable "service_subtype" {
  type        = string
  description = "The service subtype name to be used when provisioning AWS resources."
  default     = "snapcenter-linux"
}

variable "team" {
  type        = string
  description = "The team name to be used when provisioning AWS resources."
  default     = "platform"
}

variable "application_subnet_pattern" {
  type        = string
  description = "The pattern to use when filtering for application subnets."
  default     = "sub-application-*"
}


variable "default_log_retention_in_days" {
  type        = string
  description = "CloudWatch log retention period"
  default     = "7"
}

variable "snapcenter_data_volume_size" {
  type        = number
  description = "The size of the SnapCenter data volume in gibibytes (GiB)"
  default     = 200
}

variable "snapcenter_data_device_name" {
  type        = string
  description = "The device name for the SnapCenter data EBS volume"
  default     = "/dev/xvdf"
}

variable "encrypt_ebs_block_device" {
  type        = bool
  description = "Defines whether the EBS volume should be encrypted"
  default     = true
}

variable "ebs_block_device_iops" {
  type        = number
  description = "The required IOPS on the EBS volume"
  default     = 3000
}

variable "ebs_block_device_throughput" {
  type        = number
  description = "The required EBS volume throughput in MiB/s"
  default     = 125
}

variable "ebs_block_device_volume_type" {
  type        = string
  description = "The type of EBS volume to provision"
  default     = "gp3"
}

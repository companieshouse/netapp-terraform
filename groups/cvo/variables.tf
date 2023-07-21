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
variable "cvo_name" {
  type        = string
  description = "Name for the resources table being created"
}

variable "cvo_instance_ami_id" {
  type        = string
  description = "An AMI Id thats used by the CVO instances, used for lookups of instance Ids to assign security groups to."
}

variable "cvo_instance_type" {
  type        = string
  description = "Instance Type to be used for the CVO Nodes, different types allowed depending on license type chosen"
}

variable "cvo_license_type" {
  type        = string
  description = "The license type for the deployment, can be standalone or HA with different licenses providing different maximum storage allowance"
}

variable "cvo_ebs_volume_size" {
  type        = number
  description = "Initial aggregate size, we are limiting this to 100GB as we want all used aggregates to be create purposefully in the same way i.e. we are not using this aggregate at all"
  default     = 100
}

variable "cvo_ebs_volume_size_unit" {
  type        = string
  description = "Unit choice for volume size, can be TB or GB. In this case we are defaulting to GB so that we can create the smallest possible aggregate on first launch"
  default     = "GB"
}

variable "cvo_is_ha" {
  type        = bool
  description = "Is this going to be a HA deployment or Standalone"
}

variable "cvo_ontap_version" {
  type        = string
  description = "The required ONTAP version. Ignored if 'use_latest_version' is set to true. The default is to use the latest version."
}

variable "cvo2_ontap_version" {
  type        = string
  description = "The required ONTAP version for the cvo upgrade. Ignored if 'use_latest_version' is set to true. The default is to use the latest version."
}

variable "enable_cvo2_deployment" {
  type        = bool
  description = "This enables and disables the deployment of the new CVO module"
  default     = false
}

variable "cvo_floating_ips" {
  type        = list(string)
  default     = [null, null, null, null]
  description = "List of Floating IPs to use if HA mode is set to 'FloatingIP'. If provided, should be of length 4 and contain 4 IP addresses outside of the VPC range."
  validation {
    condition     = length(var.cvo_floating_ips) == 4
    error_message = "Invalid input for cvo_floating_ips, requires list with 4 entries."
  }
}

variable "connector_account_access_id" {
  type        = string
  description = "The credential ID as found in the NetApp Connector credentials page, custom per account and must exist before deployment"
  default     = null
}

variable "netapp_connector_ip" {
  type        = string
  description = "The full CIDR formatted IP of the Connector instance so that we can allow it to access CVO security groups"
  default     = "10.44.13.97/32"
}

variable "netapp_unifiedmanager_ip" {
  type        = string
  description = "The full CIDR formatted IP of the Unified Manager instance so that we can allow it to access CVO security groups"
  default     = "10.44.13.208/32"
}

variable "netapp_insight_ip" {
  type        = string
  description = "The full CIDR formatted IP of the Unified Manager instance so that we can allow it to access CVO security groups"
  default     = "10.44.13.68/32"
}

variable "vpc_ingress_cidrs" {
  type        = list(string)
  description = "A list of CIDR blocks to allow access, will be used with predefined port(s)."
  default     = []
}

variable "client_ips" {
  type        = list(any)
  description = "The full CIDR formatted IPs of the client networks that need to access CVO"
}

variable "client_ips_icmp" {
  type        = list(any)
  description = "The full CIDR formatted IPs of the client networks that need ICMP connectivity to CVO"
}

variable "client_ports" {
  type        = list(any)
  description = "A list of ports to allow from on-premise ranges"
  default     = []
}

variable "nfs_cifs_cidrs" {
  type        = list(any)
  description = "A list of CIDRs to allow NFS/CIFS access from"
  default     = []
}

variable "nfs_cifs_ports" {
  type        = list(any)
  description = "A list of ports to allow from on-premise ranges"
  default     = []
}

variable "nfs_ports" {
  type        = list(any)
  description = "A list of ports and protocols used for NFS client access"
  default     = [
                  { "protocol" = "tcp", "port" = 111 },
                  { "protocol" = "udp", "port" = 111 },
                  { "protocol" = "tcp", "port" = 2049 },
                  { "protocol" = "udp", "port" = 2049 },
                  { "protocol" = "tcp", "port" = 635 },
                  { "protocol" = "udp", "port" = 635 },
                  { "protocol" = "tcp", "port" = 4045, "to_port" = 4046 },
                  { "protocol" = "udp", "port" = 4045, "to_port" = 4046 },
                  { "protocol" = "tcp", "port" = 4049 },
                  { "protocol" = "udp", "port" = 4049 }
                ]
}

variable "nfs_client_cidrs" {
  type        = list(any)
  description = "A list of CIDRs requiring NFS access from outside of the home VPC"
  default     = []
}

variable "cifs_ports" {
  type        = list(any)
  description = "A list of ports and protocols used for CIFS client access"
  default     = [
                  { "protocol" = "udp", "port" = 137, "to_port" = 138 },
                  { "protocol" = "tcp", "port" = 139 },
                  { "protocol" = "tcp", "port" = 445 },
                ]
}

variable "cifs_client_cidrs" {
  type        = list(any)
  description = "A list of CIDRs requiring CIFS access from outside of the home VPC"
  default     = []
}

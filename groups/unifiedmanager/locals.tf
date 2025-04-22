# ------------------------------------------------------------------------
# Locals
# ------------------------------------------------------------------------
locals {
  account_ids          = data.vault_generic_secret.account_ids.data
  admin_cidrs          = values(data.vault_generic_secret.internal_cidrs.data)
  unified_manager_data = data.vault_generic_secret.unified_manager.data
  iboss_cidr           = [for entry in data.aws_ec2_managed_prefix_list.iboss.entries : entry.cidr if entry.description == "iBoss VPN" ]

  internal_fqdn = "${replace(var.aws_account, "-", "")}.aws.internal"



  default_tags = {
    Terraform = "true"
    Project   = var.account
    Region    = var.aws_region
  }
}

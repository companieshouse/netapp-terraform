# ------------------------------------------------------------------------
# Locals
# ------------------------------------------------------------------------
locals {
  account_ids          = data.vault_generic_secret.account_ids.data
  admin_cidrs          = data.aws_ec2_managed_prefix_list.admin_cidr_ranges
  unified_manager_data = data.vault_generic_secret.unified_manager.data

  internal_fqdn = "${replace(var.aws_account, "-", "")}.aws.internal"



  default_tags = {
    Terraform = "true"
    Project   = var.account
    Region    = var.aws_region
  }
}

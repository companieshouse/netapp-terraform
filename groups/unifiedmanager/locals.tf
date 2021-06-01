# ------------------------------------------------------------------------
# Locals
# ------------------------------------------------------------------------
locals {
  account_ids          = data.vault_generic_secret.account_ids.data
  admin_cidrs          = values(data.vault_generic_secret.internal_cidrs.data)
  unified_manager_data = data.vault_generic_secret.unified_manager.data

  internal_fqdn = "${replace(var.aws_account, "-", "")}.aws.internal"



  default_tags = {
    Terraform = "true"
    Project   = var.account
    Region    = var.aws_region
  }
}
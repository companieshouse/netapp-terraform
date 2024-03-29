# ------------------------------------------------------------------------
# Locals
# ------------------------------------------------------------------------
locals {
  account_ids                 = data.vault_generic_secret.account_ids.data
  admin_cidrs                 = values(data.vault_generic_secret.internal_cidrs.data)
  netapp_account_data         = data.vault_generic_secret.netapp_account.data
  netapp_connector_input_data = data.vault_generic_secret.netapp_connector_input.data

  internal_fqdn = "${replace(var.aws_account, "-", "")}.aws.internal"

  default_tags = {
    Terraform = "true"
    Project   = var.account
    Region    = var.aws_region
  }
}

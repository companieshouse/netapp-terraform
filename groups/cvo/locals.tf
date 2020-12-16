# ------------------------------------------------------------------------
# Locals
# ------------------------------------------------------------------------
locals {
  account_ids           = data.vault_generic_secret.account_ids.data
  admin_cidrs           = values(data.vault_generic_secret.internal_cidrs.data)
  netapp_account_data   = data.vault_generic_secret.netapp_account.data
  netapp_connector_data = data.vault_generic_secret.netapp_connector.data
  netapp_cvo_data       = data.vault_generic_secret.netapp_cvo.data

  internal_fqdn = format("%s.%s.aws.internal", split("-", var.aws_account)[1], split("-", var.aws_account)[0])

  netapp_connector_cidrs = [
    "10.44.12.0/24",
    "10.44.13.0/24",
    "10.44.14.0/24"
  ]

  default_tags = {
    Terraform = "true"
    Project   = "Storage"
    Region    = var.aws_region
  }
}
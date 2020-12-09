# ------------------------------------------------------------------------
# Locals
# ------------------------------------------------------------------------
locals {
  admin_cidrs   = values(data.vault_generic_secret.internal_cidrs.data)
  internal_fqdn = "${replace(var.aws_account, "-", "")}.aws.internal"
  
  default_tags = {
    Terraform = "true"
    Project   = var.account
    Region    = var.aws_region
  }
}
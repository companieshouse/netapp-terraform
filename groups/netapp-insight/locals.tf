# ------------------------------------------------------------------------
# Locals
# ------------------------------------------------------------------------
locals {
  account_ids         = data.vault_generic_secret.account_ids.data
  admin_cidrs         = values(data.vault_generic_secret.internal_cidrs.data)
  netapp_insight_data = data.vault_generic_secret.netapp-insight.data

  internal_fqdn = "${replace(var.aws_account, "-", "")}.aws.internal"

  security_kms_keys_data = data.vault_generic_secret.security_kms_keys.data
  ssm_kms_key_id         = local.security_kms_keys_data["session-manager-kms-key-arn"]

  security_s3_data            = data.vault_generic_secret.security_s3_buckets.data
  session_manager_bucket_name = local.security_s3_data["session-manager-bucket-name"]

  default_tags = {
    Terraform = "true"
    Project   = var.account
    Region    = var.aws_region
  }
}
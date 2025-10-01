locals {
  vpc_prefix = split("-", var.aws_account)[0]

  dns_zone_suffix_dynamic = "${local.vpc_prefix}.aws.internal"

  application_subnet_ids_by_az = values(zipmap(
    data.aws_subnet.application[*].availability_zone,
    data.aws_subnet.application[*].id
  ))

  common_tags = {
    Environment    = var.environment
    Service        = var.service
    ServiceSubType = var.service_subtype
    Team           = var.team
  }

  common_resource_name = "${var.environment}-${var.service_subtype}"
  dns_zone             = "${var.environment}.${local.dns_zone_suffix_dynamic}"

  security_s3_data            = data.vault_generic_secret.security_s3_buckets.data
  session_manager_bucket_name = local.security_s3_data.session-manager-bucket-name

  security_kms_keys_data = data.vault_generic_secret.security_kms_keys.data
  ssm_kms_key_id         = local.security_kms_keys_data.session-manager-kms-key-arn

  kms_keys                = data.vault_generic_secret.kms_keys.data
  cloudwatch_logs_kms_key = local.kms_keys.logs

  account_ids_secrets = jsondecode(data.vault_generic_secret.account_ids.data_json)
  ami_owner_id        = local.account_ids_secrets["shared-services"]

  sns_email_secret = var.environment != "development" ? data.vault_generic_secret.sns_email[0].data : {}
  linux_sns_email  = var.environment != "development" ? local.sns_email_secret["linux-email"] : ""

  snapcenter_ssh_secrets       = data.vault_generic_secret.snapcenter_ssh.data
  ssh_public_key               = local.snapcenter_ssh_secrets["aws_public_key"]

  snapcenter_kms_secrets       = data.vault_generic_secret.snapcenter_kms.data
  kms_key_alias                = local.snapcenter_kms_secrets["kms_key_alias"]

  snapcenter_s3_secrets        = data.vault_generic_secret.snapcenter_s3.data
  shared_resources_bucket_name = local.snapcenter_s3_secrets["s3_resources_bucket"]
}

module "unified_manager_profile" {
  source = "git@github.com:companieshouse/terraform-modules//aws/instance_profile?ref=tags/1.0.40"

  name         = "unified_manager_profile"
  enable_SSM   = true
  kms_key_refs = ["alias/${var.account}/${var.region}/ebs"]

  custom_statements = [
    {
      sid       = "aiqumAccess"
      effect    = "Allow"
      resources = [
        module.aiqum_backup_bucket.s3_bucket_arn,
        "${module.aiqum_backup_bucket.s3_bucket_arn}/*"
      ]
      actions   = [
        "s3:Get*",
        "s3:List*",
        "s3:Put*"
      ]
    }
  ]
}
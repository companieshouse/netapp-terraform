data "aws_ec2_managed_prefix_list" "administration_cidr_ranges" {
  name = "administration-cidr-ranges"
}

data "aws_ec2_managed_prefix_list" "shared_services_build_cidr_ranges" {
  name = "shared-services-management-cidrs"
}

data "aws_kms_alias" "ebs" {
  name = local.kms_key_alias
}

data "aws_route53_zone" "snapcenter_linux" {
  name   = local.dns_zone
  vpc_id = data.aws_vpc.main.id
}

data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["vpc-${local.vpc_prefix}-${var.environment}"]
  }
}

data "aws_subnets" "application" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }

  filter {
    name   = "tag:Name"
    values = [var.application_subnet_pattern]
  }
}

data "aws_subnet" "application" {
  count = length(data.aws_subnets.application.ids)
  id    = tolist(data.aws_subnets.application.ids)[count.index]
}

data "aws_ami" "rhel9_base" {
  most_recent = true
  name_regex  = "^rhel9-base-\\d.\\d.\\d"

  filter {
    name   = "name"
    values = ["rhel9-base-${var.ami_version_pattern}"]
  }

  filter {
    name   = "owner-id"
    values = [local.ami_owner_id]
  }
}

data "vault_generic_secret" "account_ids" {
  path = "aws-accounts/account-ids"
}

data "vault_generic_secret" "kms_keys" {
  path = "aws-accounts/${var.aws_account}/kms"
}

data "vault_generic_secret" "security_s3_buckets" {
  path = "aws-accounts/security/s3"
}

data "vault_generic_secret" "sns_email" {
  count = var.environment != "development" ? 1 : 0
  path  = "applications/${var.aws_account}-${var.aws_region}/monitoring"
}

data "vault_generic_secret" "security_kms_keys" {
  path = "aws-accounts/security/kms"
}

data "vault_generic_secret" "snapcenter_secrets" {
  path = "/applications/${var.aws_account}-${var.aws_region}/netapp/snapcenter-linux"
}

data "template_file" "userdata" {
  count = var.instance_count
  
  template = file("${path.module}/templates/user_data.tpl")
  
  vars = {
    HOSTNAME = "${var.service_subtype}-${count.index + 1}.${local.dns_zone}"
  }
}

data "aws_vpc" "vpc" {
  tags = {
    Name = "vpc-${var.aws_account}"
  }
}

data "aws_subnet" "monitor_b" {
  filter {
    name   = "tag:Name"
    values = ["sub-monitor-b"]
  }
}

data "aws_route53_zone" "private_zone" {
  name         = local.internal_fqdn
  private_zone = true
}

data "aws_kms_key" "ebs" {
  key_id = "alias/${var.account}/${var.region}/ebs"
}

data "vault_generic_secret" "account_ids" {
  path = "aws-accounts/account-ids"
}

data "vault_generic_secret" "unified_manager" {
  path = "applications/${var.aws_account}-${var.aws_region}/netapp/${var.application}"
}

data "aws_ami" "unified_manager" {
  most_recent = true
  owners      = [data.vault_generic_secret.account_ids.data["development"]]

  filter {
    name = "name"
    values = [
      var.ami_name,
    ]
  }

  filter {
    name = "state"
    values = [
      "available",
    ]
  }
}

data "aws_ec2_managed_prefix_list" "admin_cidr_ranges" {
  name = "administration-cidr-ranges"
}

data "aws_ec2_managed_prefix_list" "admin" {
  filter {
    name   = "prefix-list-name"
    values = [var.admin_prefix_list_name]
  }
}

data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["vpc-${var.aws_account}"]
  }
}

data "aws_kms_key" "ebs_key" {
  key_id = local.kms_secret_data["ebs"]
}

data "vault_generic_secret" "ec2_data" {
  path = "applications/${var.aws_account}-${var.aws_region}/${var.service}/${var.application}/ec2"
}

data "vault_generic_secret" "kms_data" {
  path = "aws-accounts/${var.aws_account}/kms"
}

data "aws_subnet" "monitor" {
   filter {
    name   = "tag:Name"
    values = [var.subnet_name]
  } 
}
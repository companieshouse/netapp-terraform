data "aws_vpc" "vpc" {
  tags = {
    Name = "vpc-${var.aws_account}"
  }
}

data "aws_subnet_ids" "monitor" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:Name"
    values = ["sub-monitor-*"]
  }
}

data "aws_route53_zone" "private_zone" {
  name         = local.internal_fqdn
  private_zone = true
}

data "vault_generic_secret" "account_ids" {
  path = "aws-accounts/account-ids"
}

data "vault_generic_secret" "internal_cidrs" {
  path = "aws-accounts/network/internal_cidr_ranges"
}

data "vault_generic_secret" "netapp_account" {
  path = "applications/${var.aws_account}-${var.aws_region}/${var.application}/account"
}

data "vault_generic_secret" "netapp_connector_input" {
  path = "applications/${var.aws_account}-${var.aws_region}/${var.application}/connector-inputs"
}

data "aws_instance" "netapp_connector" {
  filter {
    name   = "tag:Name"
    values = ["${local.connector_name}-001"]
  }

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }


  depends_on = [
    module.netapp_connector
  ]
}

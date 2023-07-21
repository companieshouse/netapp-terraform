data "aws_vpc" "vpc" {
  tags = {
    Name = "vpc-${var.aws_account}"
  }
}

data "aws_subnet_ids" "storage" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:Name"
    values = ["sub-storage-*"]
  }
}

data "aws_route_table" "private" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:Name"
    values = ["rtb-${var.account}-001"]
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
  path = "applications/shared-services-${var.aws_region}/netapp/account"
}

data "vault_generic_secret" "netapp_connector" {
  path = "applications/shared-services-${var.aws_region}/netapp/connector-details"
}

data "vault_generic_secret" "netapp_cvo" {
  path = "applications/${var.aws_account}-${var.aws_region}/netapp/cvo-inputs"
}

data "aws_network_interfaces" "netapp" {

  tags = {
    "aws:cloudformation:stack-name" = "cvonetapp${var.account}001"
  }

  filter {
    name   = "subnet-id"
    values = data.aws_subnet_ids.storage.ids
  }

}

data "aws_network_interfaces" "netapp2" {
  count  = var.enable_cvo2_deployment ? 1 : 0

  tags = {
    "aws:cloudformation:stack-name" = "dev-cvo"
  }

  filter {
    name   = "subnet-id"
    values = data.aws_subnet_ids.storage.ids
  }

}

output "nics" {
  value = data.aws_network_interfaces.netapp.ids
}
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

data "aws_instances" "cvo_instances" {
  instance_tags = {
    WorkingEnvironment = "cvonetapp${var.account}001"
  }

  filter {
    name   = "image-id"
    values = [var.cvo_instance_ami_id]
  }

  instance_state_names = ["running"]

  depends_on = [
    module.cvo
  ]
}

data "aws_instance" "cvo_instance" {
  for_each = toset(data.aws_instances.cvo_instances.ids)

  instance_id = each.value

}
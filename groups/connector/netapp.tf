resource "aws_key_pair" "netapp" {
  key_name   = format("%s-%s", var.application, "connector")
  public_key = local.netapp_connector_input_data["public-key"]
}

module "netapp_connector" {
  source = "git::git@github.com:companieshouse/terraform-modules//aws/netapp_cloudmanager_connector_aws?ref=update/netapp-modules-multi-account-deployments"

  name          = format("%s-%s-%s", var.application, "connector", "001")
  vpc_id        = data.aws_vpc.vpc.id
  company_name  = var.cloud_manager_company_name
  instance_type = var.cloud_manager_instance_type
  subnet_id     = coalesce(data.aws_subnet_ids.monitor.ids...)
  set_public_ip = var.cloud_manager_set_public_ip
  key_pair_name = aws_key_pair.netapp.key_name

  netapp_account_id = local.netapp_account_data["account-id"]
  netapp_cvo_accountIds = [
    local.account_ids["heritage-development"],
    local.account_ids["heritage-staging"],
    local.account_ids["heritage-live"]
  ]

  ingress_ports = var.cloud_manager_ingress_ports

  egress_ports = var.cloud_manager_egress_ports

  ingress_cidr_blocks = concat(
    local.admin_cidrs
  )

  egress_cidr_blocks = ["0.0.0.0/0"]

  tags = merge(
    local.default_tags,
    map(
      "Account", var.aws_account,
      "ServiceTeam", "Storage"
    )
  )
}
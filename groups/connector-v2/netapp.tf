resource "aws_key_pair" "netapp" {
  key_name   = local.connector_name
  public_key = local.netapp_connector_input_data["public-key"]
}

module "netapp_connector" {
  source = "git::git@github.com:companieshouse/terraform-modules//aws/netapp_cloudmanager_connector_aws?ref=tags/1.0.321"

  name          = local.connector_instance_name
  vpc_id        = data.aws_vpc.vpc.id
  company_name  = var.cloud_manager_company_name
  instance_type = var.cloud_manager_instance_type
  subnet_id     = coalesce(data.aws_subnet_ids.monitor.ids...)
  set_public_ip = var.cloud_manager_set_public_ip
  key_pair_name = aws_key_pair.netapp.key_name

  # Set to false because of an issue with the app level connector service, terraform wants to build a new one which we do not want
  build_connector   = false
  netapp_account_id = local.netapp_account_data["account-id"]
  netapp_cvo_accountIds = [
    local.account_ids["heritage-development"],
    local.account_ids["heritage-staging"],
    local.account_ids["heritage-live"],
    local.account_ids["finance-development"],
    local.account_ids["finance-staging"],
    local.account_ids["finance-live"]
  ]

  cvo_connector_role_names = var.cvo_connector_role_names

  ingress_ports = var.cloud_manager_ingress_ports

  egress_ports = var.cloud_manager_egress_ports

  ingress_cidr_blocks = concat(
    local.admin_cidrs,
    local.iboss_cidrs
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

resource "aws_security_group_rule" "cvo_ingress" {
  security_group_id = module.netapp_connector.occm_security_group_id
  description       = "Allow CVO clusters to communicate with Connector for updates"

  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = local.cvo_cidrs
}

resource "aws_security_group_rule" "cvo_ingress_hosts" {
  security_group_id = module.netapp_connector.occm_security_group_id
  description       = "Allow CVO hosts to communicate with Connector for updates"

  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = local.cvo_hosts
}

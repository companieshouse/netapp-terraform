resource "aws_key_pair" "deployer" {
  key_name   = "netapp-manager"
  public_key = 
}

module "netapp_connector" {
  source = "git::git@github.com:companieshouse/terraform-modules//aws/netapp_cloudmanager_connector_aws?ref=tags/1.0.0"

  name              = format("%s%s", var.name, "001")
  vpc_id            = data.aws_vpc.vpc.id
  region            = var.region
  company_name      = var.cloud_manager_company_name
  instance_type     = var.cloud_manager_instance_type
  subnet_id         = coalesce(data.aws_subnet_ids.monitor.ids...)
  set_public_ip     = var.cloud_manager_set_public_ip
  key_pair_name     = var.cloud_manager_key_pair_name
  netapp_account_id = var.cloud_manager_netapp_account_id

  ingress_ports = var.cloud_manager_ingress_ports

  egress_ports = var.cloud_manager_egress_ports

  ingress_cidr_blocks = concat([
    local.admin_cidrs,
  ])

  egress_cidr_blocks = [
    local.admin_cidrs,
    "0.0.0.0/0"
  ]

  tags = merge(
    local.default_tags,
    map(
      "Account", var.aws_account,
      "ServiceTeam", "Storage"
    )
  )
}
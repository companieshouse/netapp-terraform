resource "aws_key_pair" "netapp_mediator_key" {
  key_name   = format("%s-%s", var.aws_account, var.cvo_name)
  public_key = local.netapp_cvo_data["public-key"]
}

module "cvo" {
  source = "git@github.com:companieshouse/terraform-modules//aws/netapp_cloudmanager_cvo_aws?ref=tags/1.0.56"

  vpc_id     = data.aws_vpc.vpc.id
  subnet_ids = data.aws_subnet_ids.storage.ids

  ## cvo setup
  name                    = format("%s-%s-%s", var.cvo_name, var.account, "001")
  instance_type           = var.cvo_instance_type
  ebs_volume_size         = var.cvo_ebs_volume_size
  ebs_volume_size_unit    = var.cvo_ebs_volume_size_unit
  license_type            = var.cvo_license_type
  is_ha                   = var.cvo_is_ha
  use_latest_version      = false
  ontap_version           = var.cvo_ontap_version
  platform_serial_numbers = try(jsondecode(local.netapp_cvo_data["node-serial-numbers"]), [null, null])
  cluster_floating_ips    = var.cvo_floating_ips
  mediator_key_pair_name  = aws_key_pair.netapp_mediator_key.key_name
  connector_client_id     = local.netapp_connector_data["connector-client-id"]
  connector_accountId     = local.account_ids["shared-services"]
  svm_password            = local.netapp_cvo_data["svm-password"]
  cloud_provider_account  = var.connector_account_access_id

  ## Security Group setting
  ingress_cidr_blocks = [
    data.aws_vpc.vpc.cidr_block
  ]

  route_table_ids = [data.aws_route_table.private.route_table_id]

  tags = merge(
    local.default_tags,
    map(
      "ServiceTeam", "Storage"
    )
  )
}

module "cvo2" {
  source = "git@github.com:companieshouse/terraform-modules//aws/netapp_cloudmanager_cvo_aws?ref=tags/1.0.56"

  vpc_id     = data.aws_vpc.vpc.id
  subnet_ids = data.aws_subnet_ids.storage.ids

  ## cvo setup
  name                    = format("%s-%s-%s", var.cvo_name, var.account, "002")
  instance_type           = var.cvo_instance_type
  ebs_volume_size         = var.cvo_ebs_volume_size
  ebs_volume_size_unit    = var.cvo_ebs_volume_size_unit
  license_type            = var.cvo_license_type
  is_ha                   = var.cvo_is_ha
  use_latest_version      = false
  cvo_ontap_version       = var.cvo2_ontap_version
  platform_serial_numbers = try(jsondecode(local.netapp_cvo_data["node-serial-numbers"]), [null, null])
  cluster_floating_ips    = var.cvo_floating_ips
  mediator_key_pair_name  = aws_key_pair.netapp_mediator_key.key_name
  connector_client_id     = local.netapp_connector_data["connector-client-id"]
  connector_accountId     = local.account_ids["shared-services"]
  svm_password            = local.netapp_cvo_data["svm-password"]
  cloud_provider_account  = var.connector_account_access_id

  ## Security Group setting
  ingress_cidr_blocks = [
    data.aws_vpc.vpc.cidr_block
  ]

  route_table_ids = [data.aws_route_table.private.route_table_id]

  tags = merge(
    local.default_tags,
    map(
      "ServiceTeam", "Storage"
    )
  )
}
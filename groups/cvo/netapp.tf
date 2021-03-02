resource "aws_key_pair" "netapp_mediator_key" {
  key_name   = format("%s-%s", var.aws_account, var.cvo_name)
  public_key = local.netapp_cvo_data["public-key"]
}

module "cvo" {
  source = "git@github.com:companieshouse/terraform-modules//aws/netapp_cloudmanager_cvo_aws?ref=tags/1.0.47"

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
    data.aws_vpc.vpc.cidr_block,
    var.netapp_connector_ip
  ]

  route_table_ids = [data.aws_route_table.private.route_table_id]

  tags = merge(
    local.default_tags,
    map(
      "ServiceTeam", "Storage"
    )
  )
}

resource "aws_security_group_rule" "onpremise" {
  for_each = { for rule in var.client_ports : rule.port => rule }

  security_group_id = module.cvo.cvo_security_group_id
  description       = "Allow on premise ranges to access CVO"

  type        = "ingress"
  from_port   = each.value.port
  to_port     = lookup(each.value, "to_port", each.value.port)
  protocol    = each.value.protocol
  cidr_blocks = local.admin_cidrs
}

resource "aws_security_group_rule" "onpremise_icmp" {
  for_each = { for rule in var.client_ports : rule.port => rule }

  security_group_id = module.cvo.cvo_security_group_id
  description       = "Allow on premise ranges to ping CVO via ICMP"

  type        = "ingress"
  from_port   = "-1"
  to_port     = "-1"
  protocol    = "icmp"
  cidr_blocks = ["172.19.235.3/32",
    "172.19.235.4/32",
    "172.19.235.1/32",
    "172.19.235.2/32"
  ]
}
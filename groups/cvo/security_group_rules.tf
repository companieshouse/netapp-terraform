resource "aws_security_group_rule" "netapp_tooling" {
  security_group_id = module.cvo.cvo_security_group_id
  description       = "Rules for NetApp Tools - Connector and Unified Manager"

  type      = "ingress"
  from_port = "-1"
  to_port   = "-1"
  protocol  = "-1"
  cidr_blocks = [
    var.netapp_connector_ip,
    var.netapp_unifiedmanager_ip,
    var.netapp_insight_ip
  ]
}

resource "aws_security_group_rule" "onpremise" {
  for_each = { for rule in var.client_ports : rule.port => rule }

  security_group_id = module.cvo.cvo_security_group_id
  description       = "Allow on premise ranges to access CVO"

  type        = "ingress"
  from_port   = each.value.port
  to_port     = lookup(each.value, "to_port", each.value.port)
  protocol    = each.value.protocol
  cidr_blocks = var.client_ips
}

resource "aws_security_group_rule" "onpremise_icmp" {

  security_group_id = module.cvo.cvo_security_group_id
  description       = "Allow only the on premise NetApp metro-cluster range to ping CVO via ICMP"

  type        = "ingress"
  from_port   = "-1"
  to_port     = "-1"
  protocol    = "icmp"
  cidr_blocks = var.client_ips_icmp
}

resource "aws_security_group_rule" "onpremise_admin" {

  security_group_id = module.cvo.cvo_security_group_id
  description       = "Allow on-premise ranges to access CVO over SSH and HTTPS for administration"
  for_each          = toset(["22", "443"])
  type              = "ingress"
  from_port         = each.value
  to_port           = each.value
  protocol          = "tcp"
  cidr_blocks       = local.admin_cidrs
}

resource "aws_security_group_rule" "cardiff_nfs_cifs" {
  for_each = { for rule in var.nfs_cifs_ports : join("_", [rule.protocol, rule.port]) => rule }

  security_group_id = module.cvo.cvo_security_group_id
  description       = "Allow Cardiff Backend range to access CVO via NFS and CIFS"

  type        = "ingress"
  from_port   = each.value.port
  to_port     = lookup(each.value, "to_port", each.value.port)
  protocol    = each.value.protocol
  cidr_blocks = var.nfs_cifs_cidrs
}

# ------------------------------------------------------------------------------
# NFS and CIFS Client Access
# ------------------------------------------------------------------------------
data "aws_network_interfaces" "cvo_data_eni" {
  filter {
    name   = "group-id"
    values = [module.cvo.cvo_security_group_id]
  }
}

resource "aws_security_group" "cvo_data_sg" {
  name        = "sgr-netapp-${var.account}-003"
  description = "Allow client access to NFS and CIFS services"
  vpc_id      = data.aws_vpc.vpc.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = merge(
    local.default_tags,
    map(
      "Name", "sgr-netapp-${var.account}-003",
      "ServiceTeam", "Storage"
    )
  )
}

resource "aws_security_group_rule" "cvo_data_nfs_cifs" {
  for_each = { for rule in var.nfs_cifs_ports : join("_", [rule.protocol, rule.port]) => rule }

  security_group_id = aws_security_group.cvo_data_sg.id
  description       = "Allow clients to access CVO via NFS and CIFS"

  type        = "ingress"
  from_port   = each.value.port
  to_port     = lookup(each.value, "to_port", each.value.port)
  protocol    = each.value.protocol
  cidr_blocks = var.nfs_cifs_cidrs
}

resource "aws_network_interface_sg_attachment" "cvo_data_sg_attachment" {
  count = length(data.aws_network_interfaces.cvo_data_eni.ids)

  security_group_id    = aws_security_group.cvo_data_sg.id
  network_interface_id = sort(data.aws_network_interfaces.cvo_data_eni.ids)[count.index]
}

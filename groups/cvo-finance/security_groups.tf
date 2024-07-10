module "netapp_secondary_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name        = "sgr-netapp-new-${var.account}-002"
  description = "Secondary security group for the NetApp CVO Service"
  vpc_id      = data.aws_vpc.vpc.id

  tags = merge(
    local.default_tags,
    map(
      "Name", "sgr-netapp-new-${var.account}-002",
      "ServiceTeam", "Storage"
    )
  )
}

module "netapp_tertiary_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name        = "sgr-netapp-new-${var.account}-003"
  description = "Tertiary security group for the NetApp CVO Service"
  vpc_id      = data.aws_vpc.vpc.id

  tags = merge(
    local.default_tags,
    map(
      "Name", "sgr-netapp-new-${var.account}-003",
      "ServiceTeam", "Storage"
    )
  )
}

resource "aws_network_interface_sg_attachment" "cvo_instance_sgr_attachment" {
  for_each = toset(data.aws_network_interfaces.netapp.ids)

  security_group_id    = module.netapp_secondary_security_group.this_security_group_id
  network_interface_id = each.value

  depends_on = [
    module.netapp_secondary_security_group,
    data.aws_network_interfaces.netapp
  ]
}

resource "aws_security_group_rule" "ingress_cidrs" {
  count = length(local.ingress_cidrs)

  description       = "Allow VPC CIDR ingress traffic on specified ports"
  security_group_id = module.netapp_secondary_security_group.this_security_group_id
  type              = "ingress"
  from_port         = local.ingress_cidrs[count.index][1]["port"]
  to_port           = lookup(local.ingress_cidrs[count.index][1], "to_port", local.ingress_cidrs[count.index][1]["port"])
  protocol          = local.ingress_cidrs[count.index][1]["protocol"]
  cidr_blocks       = [local.ingress_cidrs[count.index][0]]
}

resource "aws_security_group_rule" "onpremise_admin" {

  security_group_id = module.netapp_secondary_security_group.this_security_group_id
  description       = "Allow on-premise ranges to access CVO over SSH and HTTPS for administration"
  for_each          = toset(["22", "443"])
  type              = "ingress"
  from_port         = each.value
  to_port           = each.value
  protocol          = "tcp"
  cidr_blocks       = local.admin_cidrs
}

resource "aws_security_group_rule" "onpremise" {
  for_each = { for rule in var.client_ports : rule.port => rule }

  security_group_id = module.netapp_secondary_security_group.this_security_group_id
  description       = "Allow on premise ranges to access CVO"

  type        = "ingress"
  from_port   = each.value.port
  to_port     = lookup(each.value, "to_port", each.value.port)
  protocol    = each.value.protocol
  cidr_blocks = var.client_ips
}

resource "aws_security_group_rule" "cardiff_nfs_cifs" {
  for_each = { for rule in var.nfs_cifs_ports : join("_", [rule.protocol, rule.port]) => rule }

  security_group_id = module.netapp_tertiary_security_group.this_security_group_id
  description       = "Allow Cardiff Backend range to access CVO via NFS and CIFS"

  type        = "ingress"
  from_port   = each.value.port
  to_port     = lookup(each.value, "to_port", each.value.port)
  protocol    = each.value.protocol
  cidr_blocks = var.nfs_cifs_cidrs
}

# ------------------------------------------------------------------------------
# Dedicated NFS Access Security Group
# ------------------------------------------------------------------------------
resource "aws_security_group" "cvo_data_nfs_sg" {
  name        = "sgr-netapp-new-${var.account}-nfs-001"
  description = "Allow client access to NFS services"
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
      "Name", "sgr-netapp-new-${var.account}-nfs-001",
      "ServiceTeam", "Storage"
    )
  )
}

resource "aws_network_interface_sg_attachment" "cvo_data_nfs_sg_attachment" {
  count = length(data.aws_network_interfaces.cvo_data_eni.ids)

  security_group_id    = aws_security_group.cvo_data_nfs_sg.id
  network_interface_id = sort(data.aws_network_interfaces.cvo_data_eni.ids)[count.index]
}


# ------------------------------------------------------------------------------
# Dedicated CIFS Access Security Group
# ------------------------------------------------------------------------------

resource "aws_security_group" "cvo_data_cifs_sg" {
  name        = "sgr-netapp-new-${var.account}-cifs-001"
  description = "Allow client access to CIFS services"
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
      "Name", "sgr-netapp-new-${var.account}-cifs-001",
      "ServiceTeam", "Storage"
    )
  )
}

resource "aws_network_interface_sg_attachment" "cvo_data_cifs_sg_attachment" {
  count = length(data.aws_network_interfaces.cvo_data_eni.ids)

  security_group_id    = aws_security_group.cvo_data_cifs_sg.id
  network_interface_id = sort(data.aws_network_interfaces.cvo_data_eni.ids)[count.index]
}

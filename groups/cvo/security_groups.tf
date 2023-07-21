module "netapp_secondary_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name        = "sgr-netapp-${var.account}-002"
  description = "Secondary security group for the NetApp CVO Service"
  vpc_id      = data.aws_vpc.vpc.id

  tags = merge(
    local.default_tags,
    map(
      "Name", "sgr-netapp-${var.account}-002",
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

resource "aws_network_interface_sg_attachment" "cvo2_instance_sgr_attachment" {
  count  = var.enable_cvo2_deployment ? 1 : 0
  
  for_each = toset(data.aws_network_interfaces.netapp2[0].ids)

  security_group_id    = module.netapp_secondary_security_group.this_security_group_id
  network_interface_id = each.value

  depends_on = [
    module.netapp_secondary_security_group,
    data.aws_network_interfaces.netapp2
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

# ------------------------------------------------------------------------------
# Dedicated NFS Access Security Group
# ------------------------------------------------------------------------------
resource "aws_security_group" "cvo_data_nfs_sg" {
  name        = "sgr-netapp-${var.account}-nfs-001"
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
      "Name", "sgr-netapp-${var.account}-nfs-001",
      "ServiceTeam", "Storage"
    )
  )
}

resource "aws_security_group" "cvo2_data_nfs_sg" {
  count  = var.enable_cvo2_deployment ? 1 : 0
  name        = "sgr-netapp-${var.account}-nfs-002"
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
      "Name", "sgr-netapp-${var.account}-nfs-002",
      "ServiceTeam", "Storage"
    )
  )
}

resource "aws_network_interface_sg_attachment" "cvo_data_nfs_sg_attachment" {
  count = length(data.aws_network_interfaces.cvo_data_eni.ids)

  security_group_id    = aws_security_group.cvo_data_nfs_sg.id
  network_interface_id = sort(data.aws_network_interfaces.cvo_data_eni.ids)[count.index]
}

resource "aws_network_interface_sg_attachment" "cvo2_data_nfs_sg_attachment" {
   count  = var.enable_cvo2_deployment ? length(data.aws_network_interfaces.cvo2_data_eni[0].ids) : 0

  security_group_id    = aws_security_group.cvo2_data_nfs_sg.id
  network_interface_id = sort(data.aws_network_interfaces.cvo2_data_eni[0].ids)[count.index]
}


# ------------------------------------------------------------------------------
# Dedicated CIFS Access Security Group
# ------------------------------------------------------------------------------

resource "aws_security_group" "cvo_data_cifs_sg" {
  name        = "sgr-netapp-${var.account}-cifs-001"
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
      "Name", "sgr-netapp-${var.account}-cifs-001",
      "ServiceTeam", "Storage"
    )
  )
}

resource "aws_security_group" "cvo2_data_cifs_sg" {
  count  = var.enable_cvo2_deployment ? 1 : 0
  name        = "sgr-netapp-${var.account}-cifs-002"
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
      "Name", "sgr-netapp-${var.account}-cifs-002",
      "ServiceTeam", "Storage"
    )
  )
}

resource "aws_network_interface_sg_attachment" "cvo_data_cifs_sg_attachment" {
  count = length(data.aws_network_interfaces.cvo_data_eni.ids)

  security_group_id    = aws_security_group.cvo_data_cifs_sg.id
  network_interface_id = sort(data.aws_network_interfaces.cvo_data_eni.ids)[count.index]
}

resource "aws_network_interface_sg_attachment" "cvo2_data_cifs_sg_attachment" {
  count  = var.enable_cvo2_deployment ? length(data.aws_network_interfaces.cvo2_data_eni[0].ids) : 0

  security_group_id    = aws_security_group.cvo2_data_cifs_sg[0].id
  network_interface_id = sort(data.aws_network_interfaces.cvo2_data_eni[0].ids)[count.index]
}

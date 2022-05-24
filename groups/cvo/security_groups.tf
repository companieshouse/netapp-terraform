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

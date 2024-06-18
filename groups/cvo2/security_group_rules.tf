# resource "aws_security_group_rule" "netapp_tooling" {
#   for_each = local.tooling_cidrs

#   security_group_id = module.cvo2.cvo_security_group_id
#   description       = "Tooling access from ${each.key}"

#   type              = "ingress"
#   from_port         = "-1"
#   to_port           = "-1"
#   protocol          = "-1"
#   cidr_blocks       = [each.value]
# }

# resource "aws_security_group_rule" "onpremise" {
#   for_each = { for rule in var.client_ports : rule.port => rule }

#   security_group_id = module.cvo2.cvo_security_group_id
#   description       = "Allow on premise ranges to access CVO"

#   type        = "ingress"
#   from_port   = each.value.port
#   to_port     = lookup(each.value, "to_port", each.value.port)
#   protocol    = each.value.protocol
#   cidr_blocks = var.client_ips
# }

# resource "aws_security_group_rule" "onpremise_icmp" {

#   security_group_id = module.cvo2.cvo_security_group_id
#   description       = "Allow only the on premise NetApp metro-cluster range to ping CVO via ICMP"

#   type        = "ingress"
#   from_port   = "-1"
#   to_port     = "-1"
#   protocol    = "icmp"
#   cidr_blocks = var.client_ips_icmp
# }

# resource "aws_security_group_rule" "onpremise_admin" {

#   security_group_id = module.cvo2.cvo_security_group_id
#   description       = "Allow on-premise ranges to access CVO over SSH and HTTPS for administration"
#   for_each          = toset(["22", "443"])
#   type              = "ingress"
#   from_port         = each.value
#   to_port           = each.value
#   protocol          = "tcp"
#   cidr_blocks       = local.admin_cidrs
# }

# resource "aws_security_group_rule" "mediator_ssh" {
#   for_each = var.cvo_is_ha ? toset(local.admin_cidrs) : []
  
#   security_group_id = data.aws_security_group.mediator[0].id
#   description       = "Allow internal ranges to access CVO mediator over SSH for administration"
#   type              = "ingress"
#   from_port         = 22
#   to_port           = 22
#   protocol          = "tcp"
#   cidr_blocks       = [each.value]
# }

# resource "aws_security_group_rule" "cardiff_nfs_cifs" {
#   for_each = { for rule in var.nfs_cifs_ports : join("_", [rule.protocol, rule.port]) => rule }

#   security_group_id = module.cvo2.cvo_security_group_id
#   description       = "Allow Cardiff Backend range to access CVO via NFS and CIFS"

#   type        = "ingress"
#   from_port   = each.value.port
#   to_port     = lookup(each.value, "to_port", each.value.port)
#   protocol    = each.value.protocol
#   cidr_blocks = var.nfs_cifs_cidrs
# }
# ------------------------------------------------------------------------------
# NFS and CIFS
# ------------------------------------------------------------------------------
# data "aws_network_interfaces" "cvo_data_eni" {
#   filter {
#     name   = "group-id"
#     values = [module.cvo2.cvo_security_group_id]
#   }
# }

# ------------------------------------------------------------------------------
# Dedciated NFS Client Access Rules
# ------------------------------------------------------------------------------
resource "aws_security_group_rule" "cvo_data_nfs" {
  for_each = { for rule in var.nfs_ports : join("_", [rule.protocol, rule.port]) => rule if length(var.nfs_client_cidrs) > 0 }

  security_group_id = aws_security_group.cvo_data_nfs_sg.id
  description       = "Allow clients to access CVO via NFS"

  type        = "ingress"
  from_port   = each.value.port
  to_port     = lookup(each.value, "to_port", each.value.port)
  protocol    = each.value.protocol
  cidr_blocks = var.nfs_client_cidrs
}


# ------------------------------------------------------------------------------
# Dedicated CIFS Client Access Rules
# ------------------------------------------------------------------------------
resource "aws_security_group_rule" "cvo_data_cifs" {
  for_each = { for rule in var.cifs_ports : join("_", [rule.protocol, rule.port]) => rule if length(local.cifs_client_cidrs) > 0 }

  security_group_id = aws_security_group.cvo_data_cifs_sg.id
  description       = "Allow clients to access CVO via CIFS"

  type        = "ingress"
  from_port   = each.value.port
  to_port     = lookup(each.value, "to_port", each.value.port)
  protocol    = each.value.protocol
  cidr_blocks = local.cifs_client_cidrs
}

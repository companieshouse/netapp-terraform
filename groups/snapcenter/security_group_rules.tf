# resource "aws_security_group_rule" "azure_ad_tcp_udp" {
#   type              = "ingress"
#   for_each          = local.azure_ad_ingress_rules_tcp_udp
#   description       = "Allow Azure AD"
#   from_port         = each.value.port
#   to_port           = each.value.port
#   protocol          = "-1"
#   cidr_blocks       = each.value.cidrs
#   security_group_id = aws_security_group.snapcenter.id
# }

# resource "aws_security_group_rule" "azure_ad_tcp" {
#   type              = "ingress"
#   for_each          = local.azure_ad_ingress_rules_tcp
#   description       = "Allow Azure AD"
#   from_port         = each.value.port
#   to_port           = each.value.port
#   protocol          = "tcp"
#   cidr_blocks       = each.value.cidrs
#   security_group_id = aws_security_group.snapcenter.id
# }

# resource "aws_security_group_rule" "azure_ad_udp" {
#   type              = "ingress"
#   for_each          = local.azure_ad_ingress_rules_udp
#   description       = "Allow Azure AD"
#   from_port         = each.value.port
#   to_port           = each.value.port
#   protocol          = "udp"
#   cidr_blocks       = each.value.cidrs
#   security_group_id = aws_security_group.snapcenter.id
# }

resource "aws_security_group_rule" "azure_ad_udp" {
  type              = "ingress"
  for_each    = {
     for n in local.azure_ad_ingress_rules_udp : n.port => n
   }
  description       = "Allow Azure AD"
  from_port         = each.value.port
  to_port           = each.value.port
  protocol          = "udp"
  cidr_blocks       = each.value.cidrs
  security_group_id = aws_security_group.snapcenter.id
}

output "test"{
    value = local.azure_ad_ingress_rules_udp
}

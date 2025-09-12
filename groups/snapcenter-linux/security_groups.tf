resource "aws_security_group" "snapcenter_linux" {
  name        = local.common_resource_name
  description = "Security group for the ${var.service_subtype} EC2 instances"
  vpc_id      = data.aws_vpc.main.id

  tags = merge(local.common_tags, {
    Name = local.common_resource_name
  })
}

# SSH Access
resource "aws_vpc_security_group_ingress_rule" "snapcenter_ssh_admin" {
  description       = "Allow SSH connectivity for administration"
  security_group_id = aws_security_group.snapcenter_linux.id
  prefix_list_id    = data.aws_ec2_managed_prefix_list.administration_cidr_ranges.id
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "snapcenter_ssh_shared_services" {
  description       = "Inbound connectivity from Concourse pipelines"
  security_group_id = aws_security_group.snapcenter_linux.id
  prefix_list_id    = data.aws_ec2_managed_prefix_list.shared_services_build_cidr_ranges.id
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

# SnapCenter Ports
resource "aws_vpc_security_group_ingress_rule" "snapcenter_main_port" {
  description       = "SnapCenter main communication port (web UI and API)"
  security_group_id = aws_security_group.snapcenter_linux.id
  prefix_list_id    = data.aws_ec2_managed_prefix_list.administration_cidr_ranges.id
  ip_protocol       = "tcp"
  from_port         = 8146
  to_port           = 8146
}

resource "aws_vpc_security_group_ingress_rule" "snapcenter_smcore_port" {
  description       = "SnapCenter SMCore communication port"
  security_group_id = aws_security_group.snapcenter_linux.id
  prefix_list_id    = data.aws_ec2_managed_prefix_list.administration_cidr_ranges.id
  ip_protocol       = "tcp"
  from_port         = 8145
  to_port           = 8145
}

resource "aws_vpc_security_group_ingress_rule" "snapcenter_scheduler_port" {
  description       = "SnapCenter Scheduler Service port"
  security_group_id = aws_security_group.snapcenter_linux.id
  prefix_list_id    = data.aws_ec2_managed_prefix_list.administration_cidr_ranges.id
  ip_protocol       = "tcp"
  from_port         = 8154
  to_port           = 8154
}

# MySQL Port
resource "aws_vpc_security_group_ingress_rule" "snapcenter_mysql" {
  description       = "MySQL database port for SnapCenter repository"
  security_group_id = aws_security_group.snapcenter_linux.id
  cidr_ipv4         = "127.0.0.1/32"
  ip_protocol       = "tcp"
  from_port         = 3306
  to_port           = 3306
}

# RabbitMQ Port
resource "aws_vpc_security_group_ingress_rule" "snapcenter_rabbitmq" {
  description       = "RabbitMQ messaging port"
  security_group_id = aws_security_group.snapcenter_linux.id
  cidr_ipv4         = "127.0.0.1/32"
  ip_protocol       = "tcp"
  from_port         = 5672
  to_port           = 5672
}

# Egress rules
resource "aws_vpc_security_group_egress_rule" "snapcenter_https_out" {
  description       = "Allow HTTPS outbound for updates and ONTAP communication"
  security_group_id = aws_security_group.snapcenter_linux.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "snapcenter_http_out" {
  description       = "Allow HTTP outbound for ONTAP communication fallback"
  security_group_id = aws_security_group.snapcenter_linux.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "snapcenter_dns_tcp" {
  description       = "Allow DNS TCP"
  security_group_id = aws_security_group.snapcenter_linux.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 53
  to_port           = 53
}

resource "aws_vpc_security_group_egress_rule" "snapcenter_dns_udp" {
  description       = "Allow DNS UDP"
  security_group_id = aws_security_group.snapcenter_linux.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "udp"
  from_port         = 53
  to_port           = 53
}

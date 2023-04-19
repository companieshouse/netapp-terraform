resource "aws_security_group" "snapcenter" {
  name        = "sgr-${var.service}-${var.application}-01"
  description = "Security group for ${title(var.service)} ${title(var.application)}"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    description     = "Allow WMI from Internal"
    from_port       = 135
    to_port         = 135
    protocol        = "tcp"
    prefix_list_ids = [data.aws_ec2_managed_prefix_list.admin.id]
  }

  ingress {
    description     = "Allow WMI from Internal"
    from_port       = 49152
    to_port         = 65535
    protocol        = "tcp"
    prefix_list_ids = [data.aws_ec2_managed_prefix_list.admin.id]
  }

  ingress {
    description     = "Allow RDP from Internal"
    from_port       = 3389
    to_port         = 3389
    protocol        = "tcp"
    prefix_list_ids = [data.aws_ec2_managed_prefix_list.admin.id]
  }

  ingress {
    description     = "Allow WinRM from Internal"
    from_port       = 5986
    to_port         = 5986
    protocol        = "tcp"
    prefix_list_ids = [data.aws_ec2_managed_prefix_list.admin.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
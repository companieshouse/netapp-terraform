# ------------------------------------------------------------------------------
# Shared Services Security Group and rules
# ------------------------------------------------------------------------------
module "unified_manager_ec2_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name        = "sgr-${var.application}-001"
  description = "Security group for the ${var.application} ec2"
  vpc_id      = data.aws_vpc.vpc.id


  ingress_cidr_blocks = local.admin_cidrs
  ingress_rules       = ["http-80-tcp", "https-443-tcp", "ssh-tcp"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 514
      to_port     = 514
      protocol    = "tcp"
      description = "Syslog Collector"
      cidr_blocks = join(",", local.admin_cidrs)
    },
    {
      from_port   = 514
      to_port     = 514
      protocol    = "udp"
      description = "Syslog Collector"
      cidr_blocks = join(",", local.admin_cidrs)
    }
  ]
  egress_rules        = ["all-all"]
}

# ------------------------------------------------------------------------------
# Shared Services EC2
# ------------------------------------------------------------------------------
resource "aws_instance" "netapp_unified_manager" {
  ami                         = data.aws_ami.unified_manager.id
  associate_public_ip_address = false
  key_name                    = aws_key_pair.ec2_keypair.key_name
  instance_type               = var.unified_manager_instance_type
  subnet_id                   = coalesce(data.aws_subnet_ids.monitor.ids...)
  vpc_security_group_ids      = [module.unified_manager_ec2_security_group.this_security_group_id]
  iam_instance_profile        = module.unified_manager_profile.aws_iam_instance_profile.name
  root_block_device {
    volume_size           = "120"
    volume_type           = "gp2"
    encrypted             = true
    kms_key_id            = data.aws_kms_key.ebs.arn
    delete_on_termination = false
  }

  user_data = templatefile("${path.module}/templates/user_data.tpl",
    {
      key = "value"
    }
  )

  tags = merge(
    local.default_tags,
    map(
      "Name", "${var.application}-001",
      "ServiceTeam", "Storage"
    )
  )
}

resource "aws_key_pair" "ec2_keypair" {
  key_name   = format("%s-%s", var.application, "001")
  public_key = local.unified_manager_data["public-key"]
}

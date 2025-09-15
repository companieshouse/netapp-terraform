resource "aws_instance" "snapcenter_linux" {
  count = var.instance_count

  ami           = data.aws_ami.rhel9_base.id
  instance_type = var.instance_type
  subnet_id     = element(local.application_subnet_ids_by_az, count.index)
  key_name      = aws_key_pair.snapcenter_linux.key_name

  user_data              = data.template_file.userdata[count.index].rendered
  iam_instance_profile   = module.instance_profile.aws_iam_instance_profile.name
  vpc_security_group_ids = [aws_security_group.snapcenter_linux.id]
  
  tags = merge(local.common_tags, {
    Name          = "${local.common_resource_name}-${count.index + 1}"
    Backup        = true
    SecurityScans = true
    Hostname      = "${var.service_subtype}-${count.index + 1}"
    Zone          = local.dns_zone
  })

  root_block_device {
    volume_size = var.root_volume_size
    encrypted   = var.encrypt_root_block_device
    iops        = var.root_block_device_iops
    kms_key_id  = data.aws_kms_alias.ebs.target_key_arn
    throughput  = var.root_block_device_throughput
    volume_type = var.root_block_device_volume_type
    
    tags = merge(local.common_tags, {
      Name   = "${local.common_resource_name}-${count.index + 1}-root"
      Backup = true
    })
  }

  lifecycle {
    ignore_changes = [
      ami,
      user_data
    ]
  }
}

resource "aws_key_pair" "snapcenter_linux" {
  key_name   = local.common_resource_name
  public_key = local.ssh_public_key
  
  tags = local.common_tags
}

resource "aws_instance" "snapcenter_linux" {
  count = var.instance_count

  ami           = data.aws_ami.rhel9_base.id
  instance_type = var.instance_type
  subnet_id     = element(local.application_subnet_ids_by_az, count.index)
  key_name      = aws_key_pair.snapcenter_linux.key_name

  iam_instance_profile   = module.instance_profile.aws_iam_instance_profile.name
  vpc_security_group_ids = [aws_security_group.snapcenter_linux.id]

  tags = merge(local.common_tags, {
    Name             = "${local.common_resource_name}-${count.index + 1}"
    Backup           = true
    SecurityScans    = true
    SnapCenterServer = true
    Hostname         = "${var.service_subtype}-${count.index + 1}" # the post-run ansible uses this tag to actually set the instance's hostname
    Zone             = local.dns_zone
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
      ami
    ]
  }
}

resource "aws_key_pair" "snapcenter_linux" {
  key_name   = local.common_resource_name
  public_key = local.ssh_public_key

  tags = local.common_tags
}

# Note: The post-run ansible needs to be run for these disks, otherwise they won't get mounted
resource "aws_ebs_volume" "snapcenter_data" {
  count             = var.instance_count
  availability_zone = aws_instance.snapcenter_linux[count.index].availability_zone
  size              = var.snapcenter_data_volume_size
  encrypted         = var.encrypt_ebs_block_device
  iops              = var.ebs_block_device_iops
  kms_key_id        = data.aws_kms_alias.ebs.target_key_arn
  throughput        = var.ebs_block_device_throughput
  type              = var.ebs_block_device_volume_type

  tags = merge(local.common_tags, {
    Name    = "${local.common_resource_name}-${count.index + 1}-snapcenter-data"
    Backup  = true
    Purpose = "SnapCenter Installation and Data"
  })
}

resource "aws_volume_attachment" "snapcenter_data_att" {
  count       = var.instance_count
  device_name = var.snapcenter_data_device_name
  volume_id   = aws_ebs_volume.snapcenter_data[count.index].id
  instance_id = aws_instance.snapcenter_linux[count.index].id
}

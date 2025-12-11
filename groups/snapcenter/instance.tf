resource "aws_key_pair" "snapcenter_ansible" {
  key_name   = "${local.common_resource_name}-ansible"
  public_key = local.snapcenter_ansible_ssh_public_key

  tags = merge(local.common_tags, {
    Repository = var.repository
  })
}

resource "aws_instance" "snapcenter" {
  count = var.instance_count

  ami           = data.aws_ami.netapp_snapcenter.id
  instance_type = var.instance_type
  subnet_id     = element(local.application_subnet_ids_by_az, count.index)
  key_name      = aws_key_pair.snapcenter_ansible.key_name

  iam_instance_profile   = module.instance_profile.aws_iam_instance_profile.name
  vpc_security_group_ids = [aws_security_group.netapp_snapcenter.id]

  tags = merge(local.common_tags, {
    Name             = local.common_resource_name
    Repository       = var.repository
    Backup           = true
    SecurityScans    = true
    SnapCenterServer = true
    Hostname         = "${var.service}-${var.service_subtype}" # the post-run ansible uses this tag to actually set the instance's hostname
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
      Name   = "${local.common_resource_name}-root"
      Backup = true
    })
  }

  # Suppress AMI data volume creation
  # The volume is created below using a snapshot which enables Terraform management (e.g. adjust throughput)
  ephemeral_block_device {
    device_name = "/dev/sdb"
    no_device   = true
  }

  lifecycle {
    ignore_changes = [
      ami
    ]
  }
}

# Create managed SnapCenter data volume using snapshot from AMI
resource "aws_ebs_volume" "snapcenter_data" {
  count             = var.instance_count
  availability_zone = aws_instance.snapcenter[count.index].availability_zone

  snapshot_id = local.data_volume_snapshot_id

  size       = var.snapcenter_data_volume_size
  type       = var.ebs_block_device_volume_type
  iops       = var.ebs_block_device_iops
  throughput = var.ebs_block_device_throughput
  encrypted  = var.encrypt_ebs_block_device
  kms_key_id = data.aws_kms_alias.ebs.target_key_arn

  tags = merge(local.common_tags, {
    Name       = "${local.common_resource_name}-data"
    Repository = var.repository
    Backup     = true
    Purpose    = "SnapCenter Installation and Data"
  })
}

resource "aws_volume_attachment" "snapcenter_data" {
  count       = var.instance_count
  device_name = var.snapcenter_data_device_name
  volume_id   = aws_ebs_volume.snapcenter_data[count.index].id
  instance_id = aws_instance.snapcenter[count.index].id
}

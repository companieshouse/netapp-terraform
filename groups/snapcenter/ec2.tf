resource "aws_instance" "snapcenter" {
  ami                    = var.ami_id
  key_name               = aws_key_pair.snapcenter.key_name
  instance_type          = var.instance_type
  monitoring             = var.monitoring
  get_password_data      = var.get_password_data
  subnet_id              = data.aws_subnet.monitor.id
  vpc_security_group_ids = [aws_security_group.snapcenter.id]
  ebs_optimized          = var.ebs_optimized

  root_block_device {
    delete_on_termination = true
    encrypted             = true
    kms_key_id            = data.aws_kms_key.ebs_key.id
    volume_size           = "100"
    volume_type           = "gp2"
  }

  ebs_block_device {
    delete_on_termination = true
    device_name           = "/dev/xvdf"
    encrypted             = true
    kms_key_id            = data.aws_kms_key.ebs_key.id
    volume_size           = "100"
    volume_type           = "gp2"
  }

  tags = {
    Name        = "${var.service}-${var.application}-01"
    Application = "${title(var.service)} ${title(var.application)}"
    ServiceTeam = "Unix/Storage"
    Backup      = "backup14"
  }
}

resource "aws_key_pair" "snapcenter" {
  key_name   = "${var.service}-${var.application}"
  public_key = local.ec2_secret_data["public-key"]
}
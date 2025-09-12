resource "aws_route53_record" "snapcenter_linux" {
  count = var.instance_count

  zone_id = data.aws_route53_zone.snapcenter_linux.zone_id
  name    = "${var.service_subtype}-${count.index + 1}"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.snapcenter_linux[count.index].private_ip]
}

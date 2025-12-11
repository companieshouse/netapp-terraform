resource "aws_route53_record" "snapcenter" {
  count = var.instance_count

  zone_id = data.aws_route53_zone.snapcenter.zone_id
  name    = "${var.service}-${var.service_subtype}"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.snapcenter[count.index].private_ip]
}

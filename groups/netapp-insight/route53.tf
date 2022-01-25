resource "aws_route53_record" "netapp_insight" {
  zone_id = data.aws_route53_zone.private_zone.zone_id
  name    = "netapp-insight"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.netapp-insight.private_ip]
}

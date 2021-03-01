resource "aws_route53_record" "netapp_unified_manager" {
  zone_id = data.aws_route53_zone.private_zone.zone_id
  name    = "netapp-unified-manager"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.netapp_unified_manager.private_ip]
}

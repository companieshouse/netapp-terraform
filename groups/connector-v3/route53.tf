resource "aws_route53_record" "netapp_connector" {
  zone_id = data.aws_route53_zone.private_zone.zone_id
  name    = local.connector_name
  type    = "A"
  ttl     = "300"
  records = [data.aws_instance.netapp_connector.private_ip]
}

resource "aws_route53_record" "cvo_nfs_dns" {
  zone_id = data.aws_route53_zone.private_zone.id
  name    = var.cvo_dns_name
  type    = "CNAME"
  ttl     = 300
  records = var.cvo.cvo_dns_record
}

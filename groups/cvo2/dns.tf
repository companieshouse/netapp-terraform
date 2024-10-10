resource "aws_route53_record" "cvo_n1_dns" {
  zone_id = data.aws_route53_zone.private_zone.id
  name    = var.cvo_n1_dns_name
  type    = "A"
  ttl     = 300
  records = [var.cvo_n1_dns_record]
}

resource "aws_route53_record" "cvo_n2_dns" {
  zone_id = data.aws_route53_zone.private_zone.id
  name    = var.cvo_n2_dns_name
  type    = "A"
  ttl     = 300
  records = [var.cvo_n2_dns_record]
}

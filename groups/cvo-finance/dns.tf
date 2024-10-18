resource "aws_route53_record" "cvo_nfs_dns" {
  count = var.cvo_multi_node ? 1 : 0

  zone_id = data.aws_route53_zone.private_zone.id
  name    = var.cvo_dns_name
  type    = "A"
  ttl     = 300
  records = [var.cvo_dns_record]
}

resource "aws_route53_record" "cvo_data_n1_dns" {
  count = var.cvo_multi_node ? 1 : 0

  zone_id = data.aws_route53_zone.private_zone.id
  name    = var.cvo_data_n1_dns_name[0]
  type    = "A"
  ttl     = 300
  records = [var.cvo_data_n1_dns_record[0]]
}

resource "aws_route53_record" "cvo_data_n2_dns" {
  count = var.cvo_multi_node ? 1 : 0

  zone_id = data.aws_route53_zone.private_zone.id
  name    = var.cvo_data_n2_dns_name[0]
  type    = "A"
  ttl     = 300
  records = [var.cvo_data_n2_dns_record[0]]
}

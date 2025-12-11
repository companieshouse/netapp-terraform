resource "aws_sns_topic" "snapcenter_alerts" {
  count = var.environment != "development" ? 1 : 0
  name  = "${local.common_resource_name}-alerts"

  tags = local.common_tags
}

resource "aws_sns_topic_subscription" "snapcenter_alerts_email" {
  count     = var.environment != "development" ? 1 : 0
  topic_arn = aws_sns_topic.snapcenter_alerts[0].arn
  protocol  = "email"
  endpoint  = local.linux_sns_email
}

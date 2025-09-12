resource "aws_sns_topic" "snapcenter_alerts" {
  name = "${local.common_resource_name}-alerts"

  tags = local.common_tags
}

resource "aws_sns_topic_subscription" "snapcenter_alerts_email" {
  topic_arn = aws_sns_topic.snapcenter_alerts.arn
  protocol  = "email"
  endpoint  = local.linux_sns_email
}

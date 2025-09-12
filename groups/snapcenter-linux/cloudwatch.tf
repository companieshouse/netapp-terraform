resource "aws_cloudwatch_log_group" "snapcenter_linux" {
  name              = "/aws/ec2/${local.common_resource_name}"
  retention_in_days = var.default_log_retention_in_days
  kms_key_id        = local.ssm_kms_key_id

  tags = local.common_tags
}

########## Instance Status Check ###############################################################
resource "aws_cloudwatch_metric_alarm" "snapcenter_instance_status" {
  count = var.instance_count

  alarm_name          = "${upper(var.aws_account)} - CRITICAL - ${local.common_resource_name}-${count.index + 1}-status-check"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Maximum"
  threshold           = "1"
  alarm_description   = "EC2 instance status check failed"
  alarm_actions       = [aws_sns_topic.snapcenter_alerts.arn]
  ok_actions          = [aws_sns_topic.snapcenter_alerts.arn]

  dimensions = {
    InstanceId = aws_instance.snapcenter_linux[count.index].id
  }

  tags = local.common_tags
}

########## CPU Utilisation #####################################################################
resource "aws_cloudwatch_metric_alarm" "snapcenter_cpu_warning" {
  count = var.instance_count

  alarm_name          = "${upper(var.aws_account)} - WARNING - ${local.common_resource_name}-${count.index + 1}-cpu"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "75"
  alarm_description   = "CPU utilization warning threshold (75%)"
  alarm_actions       = [aws_sns_topic.snapcenter_alerts.arn]
  ok_actions          = [aws_sns_topic.snapcenter_alerts.arn]

  dimensions = {
    InstanceId = aws_instance.snapcenter_linux[count.index].id
  }

  tags = local.common_tags
}

resource "aws_cloudwatch_metric_alarm" "snapcenter_cpu_critical" {
  count = var.instance_count

  alarm_name          = "${upper(var.aws_account)} - CRITICAL - ${local.common_resource_name}-${count.index + 1}-cpu"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "95"
  alarm_description   = "CPU utilization critical threshold (95%)"
  alarm_actions       = [aws_sns_topic.snapcenter_alerts.arn]
  ok_actions          = [aws_sns_topic.snapcenter_alerts.arn]

  dimensions = {
    InstanceId = aws_instance.snapcenter_linux[count.index].id
  }

  tags = local.common_tags
}

########## Root Disk Usage #####################################################################
resource "aws_cloudwatch_metric_alarm" "snapcenter_disk_warning" {
  count = var.instance_count

  alarm_name          = "${upper(var.aws_account)} - WARNING - ${local.common_resource_name}-${count.index + 1}-root-disk"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "disk_used_percent"
  namespace           = "CWAgent"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "Root disk usage warning threshold (80%)"
  alarm_actions       = [aws_sns_topic.snapcenter_alerts.arn]
  ok_actions          = [aws_sns_topic.snapcenter_alerts.arn]

  dimensions = {
    InstanceId = aws_instance.snapcenter_linux[count.index].id
    path       = "/"
  }

  tags = local.common_tags
}

resource "aws_cloudwatch_metric_alarm" "snapcenter_disk_critical" {
  count = var.instance_count

  alarm_name          = "${upper(var.aws_account)} - CRITICAL - ${local.common_resource_name}-${count.index + 1}-root-disk"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "disk_used_percent"
  namespace           = "CWAgent"
  period              = "300"
  statistic           = "Average"
  threshold           = "90"
  alarm_description   = "Root disk usage critical threshold (90%)"
  alarm_actions       = [aws_sns_topic.snapcenter_alerts.arn]
  ok_actions          = [aws_sns_topic.snapcenter_alerts.arn]

  dimensions = {
    InstanceId = aws_instance.snapcenter_linux[count.index].id
    path       = "/"
  }

  tags = local.common_tags
}

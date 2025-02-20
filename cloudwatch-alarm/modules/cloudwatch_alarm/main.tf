resource "aws_sns_topic" "log_alarm_topic" {
  name = "log_alarm_topic"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.log_alarm_topic.arn
  protocol  = "email"
  endpoint  = var.email_address
}

resource "aws_cloudwatch_log_metric_filter" "log_filter" {
  log_group_name = var.log_group_name
  name           = "error_log_filter"
  pattern        = var.log_pattern
  metric_transformation {
    name      = "ErrorCount"
    namespace = "Custom/Logs"
    value     = "1"
    unit      = "Count"
  }
}

resource "aws_cloudwatch_metric_alarm" "log_alarm" {
  alarm_name          = "LogErrorAlarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ErrorCount"
  namespace           = "Custom/Logs"
  period              = 60
  statistic           = "Sum"
  threshold           = var.threshold
  alarm_description   = "This alarm triggers when the specified log pattern exceeds the threshold in a minute."
  actions_enabled     = true
  alarm_actions       = [aws_sns_topic.log_alarm_topic.arn]

  dimensions = {
    LogGroupName = var.log_group_name
  }
}



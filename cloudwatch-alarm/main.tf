provider "aws" {
  region = "us-west-1"
}

module "cloudwatch_alarm" {
  source        = "./modules/cloudwatch_alarm"
  email_address = "Shaikk.afreen@gmail.com"
  log_group_name = "cloudplatform"
  log_pattern   = "ERROR"
  threshold     = 10
}

output "sns_topic_arn" {
  value = module.cloudwatch_alarm.log_alarm_topic_arn
}


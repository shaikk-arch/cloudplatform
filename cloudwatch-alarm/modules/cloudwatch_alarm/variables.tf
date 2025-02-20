variable "email_address" {
  description = "The email address to notify when the alarm is triggered."
  type        = string
}

variable "log_group_name" {
  description = "The name of the CloudWatch Log Group to monitor."
  type        = string
}

variable "log_pattern" {
  description = "The pattern to look for in the logs (e.g., 'ERROR')."
  type        = string
  default     = "ERROR"
}

variable "threshold" {
  description = "The threshold number of occurrences in one minute to trigger the alarm."
  type        = number
  default     = 10
}


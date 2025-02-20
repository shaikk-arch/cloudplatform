variable "vpc_id" {
  description = "AWS Cloud VPC ID"
  type        = string
  default     = "vpc-094ecbccf0550e0fd"
}

variable "subnets" {
  description = "AWS Cloud VPC Subnets"
  type    = list(string)
  default = ["subnet-0591c5cd5c1d2a3ab", "subnet-001a2bbd8ba9a7939"]
}



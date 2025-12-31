variable "project_name" {
  description = "EC2 Worker 3000"
  type        = string
  default     = "ec2-bootstrap"
}

variable "iam_role_name" {
  description = "Name of EC2 IAM role to attach CloudWatch Logs permissions"
  type        = string
}

variable "log_retention_days" {
  description = "Number of days to retain logs in CloudWatch"
  type        = number
  default     = 7
}

variable "tags" {
  description = "Tags to apply to CloudWatch log groups"
  type        = map(string)
  default     = {}
}


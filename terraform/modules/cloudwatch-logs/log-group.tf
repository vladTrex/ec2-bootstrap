resource "aws_cloudwatch_log_group" "app" {
  name              = "/ec2/${var.project_name}/app"
  retention_in_days = var.log_retention_days

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "docker" {
  name              = "/ec2/${var.project_name}/docker"
  retention_in_days = var.log_retention_days

  tags = var.tags
}


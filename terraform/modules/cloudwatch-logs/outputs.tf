output "app_log_group_name" {
  description = "Name of the application CloudWatch log group"
  value       = aws_cloudwatch_log_group.app.name
}

output "docker_log_group_name" {
  description = "Name of the Docker CloudWatch log group"
  value       = aws_cloudwatch_log_group.docker.name
}


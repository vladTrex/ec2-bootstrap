output "instance_id" {
  description = "ID of the EC2 instance"
  value       = module.ec2.instance_id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = module.ec2.instance_public_ip
}

output "instance_public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = module.ec2.instance_public_dns
}

output "app_url" {
  description = "URL to access the application"
  value       = "http://${module.ec2.instance_public_ip}:3030"
}

output "cloudwatch_app_log_group" {
  description = "CloudWatch log group for application logs"
  value       = module.cloudwatch_logs.app_log_group_name
}

output "cloudwatch_docker_log_group" {
  description = "CloudWatch log group for Docker logs"
  value       = module.cloudwatch_logs.docker_log_group_name
}


output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.this.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.this.public_ip
}

output "instance_public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_instance.this.public_dns
}

output "iam_role_name" {
  description = "Name of the IAM role attached to EC2 instance"
  value       = aws_iam_role.this.name
}

output "iam_role_arn" {
  description = "ARN of the IAM role attached to EC2 instance"
  value       = aws_iam_role.this.arn
}

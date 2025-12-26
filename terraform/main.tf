terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "app_sg" {
  name        = "ec2-bootstrap-sg"
  description = "Security group for EC2 bootstrap app"

  ingress {
    from_port   = 3030
    to_port     = 3030
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-bootstrap-sg"
  }
}

resource "aws_instance" "app" {
  ami                    = var.ami_id != "" ? var.ami_id : data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  key_name               = var.key_name

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y docker
              systemctl start docker
              systemctl enable docker
              usermod -a -G docker ec2-user
              
              docker run -d \
                --name ec2-bootstrap \
                --restart unless-stopped \
                -p 3030:3030 \
                ${var.docker_image}
              EOF

  tags = {
    Name = "ec2-bootstrap-app"
  }
}

output "instance_public_ip" {
  value       = aws_instance.app.public_ip
  description = "Public IP address of the EC2 instance"
}

output "instance_public_dns" {
  value       = aws_instance.app.public_dns
  description = "Public DNS name of the EC2 instance"
}

output "app_url" {
  value       = "http://${aws_instance.app.public_ip}:3030"
  description = "URL to access the application"
}


provider "aws" {
  region = var.aws_region
}

module "security_group" {
  source = "./modules/security-group"

  name        = "${var.project_name}-sg"
  description = "Security group for ${var.project_name}"

  ingress_rules = [
    {
      from_port   = 3030
      to_port     = 3030
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  tags = var.tags
}

module "ec2" {
  source = "./modules/ec2"

  ami_id          = var.ami_id
  instance_type   = var.instance_type
  security_group_ids = [module.security_group.security_group_id]
  key_name        = var.key_name
  name            = "${var.project_name}-app"

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y docker
    systemctl start docker
    systemctl enable docker
    usermod -a -G docker ec2-user
    
    docker run -d \
      --name ${var.project_name} \
      --restart unless-stopped \
      -p 3030:3030 \
      ${var.docker_image}
  EOF

  tags = var.tags
}

module "cloudwatch_logs" {
  source = "./modules/cloudwatch-logs"

  project_name        = var.project_name
  iam_role_name       = module.ec2.iam_role_name
  log_retention_days  = var.cloudwatch_log_retention_days
  tags                = var.tags

  depends_on = [module.ec2]
}

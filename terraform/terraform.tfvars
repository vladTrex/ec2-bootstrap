aws_region    = "eu-central-1"
project_name  = "ec2-bootstrap"
instance_type = "t2.micro"
key_name      = "ec2-keypair-v2"
docker_image  = "ec2-bootstrap:latest"

tags = {
  Environment = "dev"
  Project     = "ec2-bootstrap"
}

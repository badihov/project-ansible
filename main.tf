terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}
resource "aws_key_pair" "ec2loginkey" {
  key_name   = "ansible_terraform"
  public_key = var.ssh_key_pair_pub
}


resource "aws_instance" "web02" {
  ami                    = var.ami-var
  instance_type          = var.instance_type-var
  key_name               = aws_key_pair.ec2loginkey.key_name
  user_data              = file("ansibleWorker.sh")
  vpc_security_group_ids = [aws_security_group.sg.id]
  tags = {
    Name = "ansible-worker"
  }
}

output "ansible-engine" {
  value = aws_instance.web01.public_ip
}
output "ansible-node-1" {
  value = aws_instance.web02.public_ip
}


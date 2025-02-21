provider "aws" {
  region = "us-east-1"  # Change to your preferred AWS region
}

# Create a new VPC
resource "aws_vpc" "new_vpc" {
  cidr_block = "10.0.0.0/16"
  
  tags = {
    Name = "new-flask-vpc"
  }
}

# Create a security group within the new VPC
resource "aws_security_group" "ecs_sg" {
  name        = "flask-app-sg-new"
  description = "Allow HTTP traffic on port 5000"
  vpc_id      = aws_vpc.new_vpc.id  # Reference the new VPC

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

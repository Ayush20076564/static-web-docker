provider "aws" {
  region = "eu-west-1"
}

resource "aws_key_pair" "aj_key" {
  key_name   = "aj-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Allow HTTP and SSH"

  ingress = [
    {
      description = "SSH"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "HTTP"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  egress = [{
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }]
}

resource "aws_instance" "web" {
  ami           = "ami-08d4ac5b634553e16" # Ubuntu 22.04 (for eu-west-1)
  instance_type = "t2.micro"
  key_name      = aws_key_pair.aj_key.key_name
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "aj-static-web"
  }

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install -y docker.io
              systemctl enable docker
              systemctl start docker
              EOF
}

output "public_ip" {
  value = aws_instance.web.public_ip
}

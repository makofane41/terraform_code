
provider "aws" {
  region     = "us-east-1"
  access_key = "###"
  secret_key = "###"
}

resource "aws_security_group" "web_server_sg" {
  name_prefix = "web_server_sg_"

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
}

resource "aws_instance" "web_server" {
  ami           = "ami-0557a15b87f6559cf"
  instance_type = "t2.micro"
  count = 1
  user_data     = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt upgrades -y
    sudo apt install apache2 -y
    sudo systemctl start apache2
    sudo systemctl enable apache2
    sudo echo "<html><body><h1>well come to server made by IAC</h1></body></html>" > /var/www/html/index.html
    EOF

  vpc_security_group_ids = [aws_security_group.web_server_sg.id]

  tags = {
    Name = "Web_serverv"
  }
}

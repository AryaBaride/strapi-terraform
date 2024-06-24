provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "strapi_instance" {
  ami             = "ami-0f58b397bc5c1f2e8"  
  instance_type   = "t2.medium"
  key_name        = aws_key_pair.generated_key.key_name
  security_groups = [aws_security_group.strapi_sg.name]

  tags = {
    Name = "StrapiServer"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nodejs npm",
      "sudo npm install -g yarn",
      "sudo npm install -g npx",
      "curl -fsSL https://get.docker.com -o get-docker.sh",
      "sh get-docker.sh",
      "sudo usermod -aG docker ubuntu",  # Change to the appropriate user for your AMI
      "sudo apt-get install -y docker-compose",
      "git clone https://github.com/AryaBaride/strapi-terraform.git /home/ubuntu/strapi-app",
      "cd /home/ubuntu/strapi-app",
      "yarn install",
      "yarn build",
      "yarn start &",
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"  # Change to the appropriate user for your AMI
      private_key = file("${var.private_key_path}")
      host        = self.public_ip
    }
  }
}

resource "aws_security_group" "strapi_sg" {
  name        = "strapi_sg"
  description = "Allow SSH and HTTP traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 ingress {
    from_port   = 1337
    to_port     = 1337
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "generated_key" {
  key_name   = "strapi_server_key"
  public_key = file("${var.public_key_path}")
}
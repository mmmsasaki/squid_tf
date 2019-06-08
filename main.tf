provider "aws" {
  region = "${var.region}"
}

terraform {
  required_version = ">= 0.11.11"

  backend "s3" {
    bucket = "mmmdev"
    key    = "squid_tf/terraform.tfstate"
    region = "eu-central-1"
  }
}

resource "aws_security_group" "gene_blog_sg" {
  name        = "gene_blog_sg"
  description = "gene_blog_sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3128
    to_port     = 3128
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
    Name = "gene_blog_sg"
  }


}

resource "aws_instance" "proxy" {
  ami                    = "${var.ami}"
  instance_type          = "t3.micro"
  user_data              = file("./user_data.sh")
  key_name               = "gene_eu_central_key"
  vpc_security_group_ids = ["${aws_security_group.gene_blog_sg.id}"]


  tags = {
    Name = "gene_blog_ec2"
  }
}

terraform {
  backend "s3" {
    bucket         = "" // TODO: fill in your s3 bucket
    region         = "ap-northeast-1"
    key            = "terraform.tfstate"
    dynamodb_table = "" // TODO: fill in your DynamoDB
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

provider "aws_southeast" {
  region = "ap-southeast-1"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}


// ap-northeast-1
resource "aws_instance" "instance" {
  ami                    = "ami-036d0684fc96830ca" // Ubuntu 20.04 LTS
  instance_type          = var.instance_type
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.sg.id]
  tags = {
    Name = terraform.workspace
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key-${terraform.workspace}"
  public_key = "" // TODO: fill in your public key
}

resource "aws_security_group" "sg" {
  name = terraform.workspace
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "id" {
  value = aws_instance.instance.id
}

output "ip" {
  value = aws_instance.instance.public_ip
}


// ap-southeast-1
resource "aws_instance" "instance_southeast" {
  ami                    = "ami-036d0684fc96830ca" // Ubuntu 20.04 LTS
  instance_type          = var.instance_type
  key_name               = aws_key_pair.deployer_southeast.key_name
  vpc_security_group_ids = [aws_security_group.sg_southeast.id]
  tags = {
    Name = terraform.workspace
  }
  provider = "aws_southeast"
}

resource "aws_key_pair" "deployer_southeast" {
  key_name   = "deployer-key-${terraform.workspace}"
  public_key = "" // TODO: fill in your public key
  provider   = "aws_southeast"
}

resource "aws_security_group" "sg_southeast" {
  name = terraform.workspace
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  provider = "aws_southeast"
}

output "id_southeast" {
  value = aws_instance.instance_southeast.id
}

output "ip_southeast" {
  value = aws_instance.instance_southeast.public_ip
}
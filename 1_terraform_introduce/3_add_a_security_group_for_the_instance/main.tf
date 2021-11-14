provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_instance" "instance" {
  ami                    = "ami-036d0684fc96830ca"   // Ubuntu 20.04 LTS
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.sg.id]
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "" // TODO: fill in your public key
}

resource "aws_security_group" "sg" {
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

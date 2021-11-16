resource "aws_instance" "instance" {
  ami                    = var.ami_id // Ubuntu 20.04 LTS
  instance_type          = var.instance_type
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.sg.id]
  tags = {
    Name = terraform.workspace
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key-${terraform.workspace}"
  public_key = var.public_key
}

resource "aws_security_group" "sg" {
  name = "${terraform.workspace}-sg"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


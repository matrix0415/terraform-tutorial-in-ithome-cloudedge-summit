provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_instance" "instance" {
  ami           = "ami-036d0684fc96830ca"   // Ubuntu 20.04 LTS
  instance_type = "t3.micro"
  key_name      = aws_key_pair.deployer.key_name
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key-default"
  public_key = "" // TODO: fill in your public key
}

output "id" {
  value = aws_instance.instance.id
}
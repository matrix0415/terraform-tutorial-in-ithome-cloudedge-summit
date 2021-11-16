provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_instance" "instance" {
  ami           = "ami-036d0684fc96830ca"   // Ubuntu 20.04 LTS
  instance_type = "t3.micro"
}

output "id" {
  value = aws_instance.instance.id
}
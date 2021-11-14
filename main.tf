terraform {
  backend "s3" {
    bucket         = "ithome-cloudsummit-terraform-states" // TODO: fill in your s3 bucket
    region         = "ap-northeast-1"
    key            = "terraform.tfstate"
    dynamodb_table = "terraform-locks" // TODO: fill in your DynamoDB
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_default_vpc" "vpc" {}
resource "aws_default_subnet" "subnet" {
  availability_zone = "ap-northeast-1a"
}

resource "aws_iam_group" "group" {
  name = "ithome-group"
}

resource "aws_iam_user" "user" {
  name = "ithome-user"
}

resource "aws_iam_group_membership" "team" {
  name = "tf-group-membership"
  users = [aws_iam_user.user.name]
  group = aws_iam_group.group.name
}

resource "aws_iam_user_ssh_key" "public_key" {
  username   = aws_iam_user.user.name
  encoding   = "SSH"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCu0QOlwx92aaSRYQ1E22goTA5L0aQTFj4JOZagXLq0u+qzsyb4DHc4csPLHnodpLXO2N89QYIlerY3zVs1L/ycffAzAW4+tL666/0GGG6j7eTV4c6toHiyVIna1eC7gWQemf3eCmIJIdVJXzHLnUdnADFYsAIQ0UYeb3KD9psPF5rY8QIYiylDltEsrQReBOaYAGMF3/C0SyEHzwpDbI8/E3QLxuii9ZI1TT+Pl3eQ1D3A817Ut+eN65Mud3nr7J8MGI8hvIst+hFCNviYOHIIBzIY+/jKIgyazX7+8Bewv0fIqr3IQJWnasCsBruChw0JZMrxwGjxRgvUfaRHxYhV hsuanku@KKBOXde-MacBook-Pro.local" // TODO: fill in your public key
}

module "ec2" {
  source                 = "git::https://github.com/KKStream/terraform-aws-ec2-jump?ref=v0.0.1"
  ami                    = "ami-036d0684fc96830ca" // Ubuntu 20.04 LTS
  instance_type          = "t3.micro"
  project_name           = "ithome"
  subnet_id              = aws_default_subnet.subnet.id
  vpc_id                 = aws_default_vpc.vpc.id
  allow_ssh_access_cidrs = ["0.0.0.0/0"]
  enabled_egress_allow_http = true
  enabled_egress_allow_https = true
  enabled_egress_allow_ntp = true
  termination_protection = false
  key_name = "hsuanku"
  user_data_base64 = module.ec2_auth.ec2_user_data_base64
}

module "ec2_auth" {
  source                      = "git::https://github.com/KKStream/terraform-aws-ec2-ssh-auth-iam?ref=v0.0.1"
  ec2_role_id                 = module.ec2.role_id
  allow_login_iam_group_names = [aws_iam_group.group.name]
}

output "ip" {
  value = module.ec2.public_ip
}
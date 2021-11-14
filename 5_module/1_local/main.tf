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

variable "public_key" {
  type = string
}

// ap-northeast-1
module "ec2" {
  source        = "./ec2"
  instance_type = var.instance_type
  public_key    = var.public_key
}


// ap-southeast-1
module "ec2_southeast" {
  source        = "./ec2"
  instance_type = var.instance_type
  public_key    = var.public_key
  providers     = {
    aws = aws_southeast
  }
}
provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "learndenops-demo-bucket"
    key   = "remote.tfstate"
    region = "us-east-1"
  }
}

data "aws_region" "current" {}

data "aws_availability_zones" "available" {}

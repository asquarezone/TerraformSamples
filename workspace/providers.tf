terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.41.0"
    }
  }
  backend "s3" {
    bucket         = "dmttfstate"
    key            = "workspacedemo/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "dmttfstate"
  }

}

provider "aws" {
  region = "us-east-1"
}
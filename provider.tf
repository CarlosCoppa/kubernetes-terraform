terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.66.0"
    }
  }

  backend "remote" {
    organization = "carlos-coppa"

    workspaces {
      name = "kubernetes"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
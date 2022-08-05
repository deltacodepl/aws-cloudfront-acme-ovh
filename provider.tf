terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0.0"
    }
    ovh = {
      source  = "ovh/ovh"
      version = ">= 0.18.0"
    }
    sops = {
      source  = "carlpett/sops"
      version = "~> 0.5"
    }
  }
  required_version = ">= 0.15"
}

provider "aws" {
  profile = "s24"
  region  = var.aws_region
}

provider "ovh" {
  endpoint           = "ovh-eu"
  application_key    = data.sops_file.demo-secret.data["ovh.application_key"]
  application_secret = data.sops_file.demo-secret.data["ovh.application_secret"]
  consumer_key       = data.sops_file.demo-secret.data["ovh.consumer_key"]
}



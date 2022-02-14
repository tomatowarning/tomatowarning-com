terraform {
  required_version = ">= 1.0.3"

  required_providers {
    aws    = "~> 3.6"
    random = ">= 2"
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = terraform.workspace
  default_tags {
    tags = {
      CostCenter  = var.app_name
      Owner       = var.owner_name
      Environment = terraform.workspace
      Terraform   = true
    }
  }
}

provider "aws" {
  alias   = "primary"
  region  = var.primary_region
  profile = terraform.workspace
  default_tags {
    tags = {
      CostCenter  = var.app_name
      Owner       = var.owner_name
      Environment = terraform.workspace
      Terraform   = true
    }
  }
}

provider "aws" {
  alias   = "secondary"
  region  = var.secondary_region
  profile = terraform.workspace
  default_tags {
    tags = {
      CostCenter  = var.app_name
      Owner       = var.owner_name
      Environment = terraform.workspace
      Terraform   = true
    }
  }
}
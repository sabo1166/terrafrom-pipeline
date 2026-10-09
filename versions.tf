terraform {
  required_version = ">= 1.6.0"

  # Local backend (default) on purpose: terrafrom-s3-pipeline is NOT used for state.
  # See README.md before moving to a remote backend.

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

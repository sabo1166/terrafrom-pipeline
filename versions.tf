terraform {
  required_version = ">= 1.6.0"

  # Local backend (default) on purpose: s3-treeaform-project-1 is NOT used for state.
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

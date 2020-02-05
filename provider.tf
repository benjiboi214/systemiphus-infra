# Settings for the AWS provider.
provider "aws" {
  version = "~> 2.22"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

terraform {
    backend "s3" {
        bucket = "systemiphus-terraform-remote-state-storage-s3"
        key = "terraform/shared-infrastructure/state"
        region = "ap-southeast-2"
        dynamodb_table = "systemiphus-state-lock"
        encrypt = true
    }
}

resource "aws_s3_bucket" "terraform-state-storage-s3" {
    bucket = "systemiphus-terraform-remote-state-storage-s3"
 
    versioning {
      enabled = true
    }
 
    lifecycle {
      prevent_destroy = true
    }
 
    tags = {
      Name = "S3 Remote Terraform State Store"
    }      
}

resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name           = "systemiphus-state-lock"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "Systemiphus Terraform State Lock Table"
  }
}
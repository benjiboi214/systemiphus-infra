# Settings for the AWS provider.
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.systemiphus_aws_region}"
}

# Used for managing the remote state backend. See personal notes for details
terraform {
    backend "s3" {
        bucket = "systemiphus-bucket"
        key = "terraform/prod/state"
        region = "ap-southeast-2"
        dynamodb_table = "systemiphus-state-lock"
        encrypt = true
    }
}
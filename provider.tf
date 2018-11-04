// Settings for each provider.
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.systemiphus_aws_region}"
}

// Wonder if provider "ansible" does anything?

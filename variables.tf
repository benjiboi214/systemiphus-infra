// Define which variables are available to terraform

variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "systemiphus_aws_region" {}
variable "systemiphus_aws_az" {}
variable "systemiphus_base_cidr_block" {}
variable "systemiphus_region_map" {
    # Used for offseting the CIDR function based on the region for VPC and Subnet config
    type = "map"
}

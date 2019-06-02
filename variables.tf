## Provider
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_region" {}

## Network
variable "primary_cidr" {}
variable "az_1" {}
variable "az_2" {}

# VPN/NAT Instance
variable "vpn_instance_size" {}

# Instances
variable "ubuntu_1604_ami" {}
variable "key_name" {}
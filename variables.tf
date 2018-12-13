// Define which variables are available to terraform

variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "systemiphus_ssh_keyname" {}
variable "systemiphus_aws_region" {}
variable "systemiphus_bastion_host_size" {}
variable "systemiphus_nat_host_size" {}

variable "systemiphus_jenkins_host_size" {}
variable "systemiphus_aws_az" {}
variable "systemiphus_base_cidr_block" {}
variable "systemiphus_region_map" {
    # Used for offseting the CIDR function based on the region for VPC and Subnet config
    type = "map"
}

variable "systemiphus_bastion_instance_host_number" {
    default = 10
}
variable "systemiphus_nat_instance_host_number" {
    default = 11
}
variable "systemiphus_openvpn_ami" {}
variable "systemiphus_nat_ami" {}
variable "systemiphus_centos_product_code" {}
variable "systemiphus_ubuntu_ami" {}
variable "protonmail_mx_records" {
    type = "list"
}
variable "protonmail_txt_records" {
    type = "list"
}
variable "systemiphus_nat_ami_name" {}
variable "protonmail_dmarc_txt_records" {
    type = "list"
}
variable "protonmail_dkim_txt_records" {
    type = "list"
}
variable "belliot_current_public_ip" {
    type="list"
}
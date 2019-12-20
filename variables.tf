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

variable "ecs_task_execution_role_name" {
  description = "ECS task execution role name"
  default = "myEcsTaskExecutionRole"
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "512"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "1024"
}

variable "jenkins_count" {
  description = "Number of docker containers to run for jenkins"
  default     = 1
}

variable "jenkins_master_task_definition_arn" {}

variable "jenkins_domain_ssl_cert_arn" {}
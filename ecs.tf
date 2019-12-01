resource "aws_ecs_cluster" "systemiphus" {
  name = "systemiphus"
}



# data "aws_ecs_container_definition" "ecs-mongo" {
#   task_definition = "${aws_ecs_task_definition.mongo.id}"
#   container_name  = "413514076128.dkr.ecr.ap-southeast-2.amazonaws.com/jenkins:latest"
# }

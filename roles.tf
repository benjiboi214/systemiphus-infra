# ECS task execution role data
data "aws_iam_policy_document" "ecs_assume_role" {
  version = "2012-10-17"
  statement {
    sid = ""
    effect = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# ECS task execution role
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${var.ecs_task_execution_role_name}"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_assume_role.json}"
}

# ECS task execution role policy attachment
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = "${aws_iam_role.ecs_task_execution_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "codedeploy_assume_role" {
  version = "2012-10-17"
  statement {
    sid = ""
    effect = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }
  }
}
# CodeDeploy execution role
resource "aws_iam_role" "deploy_service_role" {
  name               = "codeDeployServiceRole"
  assume_role_policy = "${data.aws_iam_policy_document.codedeploy_assume_role.json}"
}

# CodeDeploy execution role policy attachment
resource "aws_iam_role_policy_attachment" "deploy_service_s3_access" {
  role       = "${aws_iam_role.deploy_service_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "deploy_service_codedeploy_access" {
  role       = "${aws_iam_role.deploy_service_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}

resource "aws_iam_role_policy_attachment" "deploy_service_ecs_access" {
  role       = "${aws_iam_role.deploy_service_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECSLimited"
}

resource "aws_iam_role_policy_attachment" "deploy_service_ecs_full_access" {
  role       = "${aws_iam_role.deploy_service_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}
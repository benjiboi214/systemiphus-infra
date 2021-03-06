# ECS task execution role data
data "aws_iam_policy_document" "ecs_assume_role" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
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

resource "aws_iam_role_policy_attachment" "ecs_task_execution_ssm_read" {
  role       = "${aws_iam_role.ecs_task_execution_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_pipeline_action" {
  role       = "${aws_iam_role.ecs_task_execution_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSCodePipelineCustomActionAccess"
}

data "aws_iam_policy_document" "codedeploy_assume_role" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
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

data "aws_iam_policy_document" "codepipeline_assume_role" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}

# CodePipeline execution role
resource "aws_iam_role" "pipeline_service_role" {
  name               = "codePipelineServiceRole"
  assume_role_policy = "${data.aws_iam_policy_document.codepipeline_assume_role.json}"
}

resource "aws_iam_role_policy_attachment" "pipeline_service_codecommit_full_access" {
  role       = "${aws_iam_role.pipeline_service_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeCommitFullAccess"
}

resource "aws_iam_role_policy_attachment" "pipeline_service_ecr_full_access" {
  role       = "${aws_iam_role.pipeline_service_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_iam_role_policy_attachment" "pipeline_service_ecs_full_access" {
  role       = "${aws_iam_role.pipeline_service_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}

resource "aws_iam_role_policy_attachment" "pipeline_codebuild_full_access" {
  role       = "${aws_iam_role.pipeline_service_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildAdminAccess"
}

resource "aws_iam_role_policy_attachment" "pipeline_codedeploy_deployer_access" {
  role       = "${aws_iam_role.pipeline_service_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployDeployerAccess"
}

## TODO CHECK THIS IS NOT A PROBLEM
resource "aws_iam_role_policy_attachment" "pipeline_codedeploy_something" {
  role       = "${aws_iam_role.pipeline_service_role.name}"
  policy_arn = "arn:aws:iam::413514076128:policy/service-role/AWSCodePipelineServiceRole-ap-southeast-2-docker_django_aws_deploy"
}

## Lambda execution role
data "aws_iam_policy_document" "lambda_assume_role" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# CodePipeline execution role
resource "aws_iam_role" "lambda_execution_role" {
  name               = "codePipelineLambdaExecutionRole"
  assume_role_policy = "${data.aws_iam_policy_document.lambda_assume_role.json}"
}

resource "aws_iam_role_policy_attachment" "pipeline_lambda_execution" {
  role       = "${aws_iam_role.lambda_execution_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "put_lifecycle_hook" {
  name = "PutLifeCycleHook"
  role = "${aws_iam_role.lambda_execution_role.id}"

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "codedeploy:PutLifecycleEventHookExecutionStatus",
            "Resource": "*"
        }
      ]
  }
  EOF
}

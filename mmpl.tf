# Logs Group Cloudwatch
# "logDriver": "awslogs",
#             "options": {
#                 "awslogs-region": "ap-southeast-2",
#                 "awslogs-stream-prefix": "ecs",
#                 "awslogs-group": "/ecs/mmpl_backend-api-staging"
#             }
resource "aws_cloudwatch_log_group" "mmpl_backend-api-staging" {
  name = "/ecs/mmpl_backend-api-staging"
}


# Task Definition
resource "aws_ecs_task_definition" "mmpl_backend_staging" {
  family                = "mmpl_backend-staging"
  container_definitions = "${file("task-definitions/mmpl_backend.api.staging.json")}"

  task_role_arn = "${aws_iam_role.ecs_task_execution_role.arn}"
  execution_role_arn = "${aws_iam_role.ecs_task_execution_role.arn}"

  network_mode = "awsvpc"
  cpu = "256"
  memory = "512"
  requires_compatibilities = ["FARGATE"]
}

## Load Balancer
# Traffic to the Jenkins LB should only come from 443 SSL
resource "aws_security_group" "mmpl_lb_staging" {
  name        = "sys-mmpl-staging-lb-sg"
  description = "Controls access to the ALB"
  vpc_id      = "${aws_vpc.primary.id}"

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "mmpl_service_staging" {
  name        = "sys-mmpl-staging-service-sg"
  description = "Controls access to the ALB"
  vpc_id      = "${aws_vpc.primary.id}"

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_alb" "mmpl_staging" {
  name            = "alb-sys-mmpl-staging"
  subnets         = ["${aws_subnet.primary_public_a.id}", "${aws_subnet.primary_public_b.id}"]
  security_groups = ["${aws_security_group.mmpl_lb_staging.id}"]
}

resource "aws_alb_target_group" "mmpl_tg_1" {
  name        = "alb-tg-sys-mmpl-staging-1"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = "${aws_vpc.primary.id}"
  target_type = "ip"

  health_check {
    healthy_threshold   = "5"
    interval            = "30"
    protocol            = "HTTP"
    port                = "traffic-port"
    matcher             = "200,301"
    timeout             = "5"
    path                = "/admin"
    unhealthy_threshold = "10"
  }
}


# resource "aws_alb_target_group" "mmpl_tg_2" {
#   name        = "alb-tg-sys-mmpl-staging-2"
#   port        = 80
#   protocol    = "HTTP"
#   vpc_id      = "${aws_vpc.primary.id}"
#   target_type = "ip"

#   health_check {
#     healthy_threshold   = "5"
#     interval            = "30"
#     protocol            = "HTTP"
#     port                = "traffic-port"
#     matcher             = "200,301"
#     timeout             = "5"
#     path                = "/admin"
#     unhealthy_threshold = "10"
#   }
# }

# # Redirect all traffic from the ALB to the target group
## Commented out because cannot set weighted target groups
# resource "aws_alb_listener" "mmpl_staging_ssl" {
#   load_balancer_arn = "${aws_alb.mmpl_staging.id}"
#   port              = "443"
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = "${var.mmpl_domain_ssl_cert_arn}"

#   default_action {
#     type             = "forward"
#     target_group_arn = "${aws_alb_target_group.mmpl_tg_1.id}"
#   }
# }

# # Redirect all HTTP requests to SSL
resource "aws_alb_listener" "mmpl_staging" {
  load_balancer_arn = "${aws_alb.mmpl_staging.id}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# # Add DNS for the Load Balancer
resource "aws_route53_record" "mmpl_staging" {
  zone_id = "${aws_route53_zone.mmpl_dns.zone_id}"
  name    = "staging.mmpl.systemiphus.com"
  type    = "A"

  alias {
    name                   = "${aws_alb.mmpl_staging.dns_name}"
    zone_id                = "${aws_alb.mmpl_staging.zone_id}"
    evaluate_target_health = true
  }
}

### Service, CodeDeploy App and Deployment Groups must be created manually as TF does no support weighted target groups in the ALB
## Service
# Jenkins Master
# resource "aws_ecs_service" "mmpl-staging" {
#   name            = "mmpl-staging"
#   cluster         = "${aws_ecs_cluster.systemiphus.id}"
#   task_definition = "${aws_ecs_task_definition.mmpl_backend_staging.arn}"
#   desired_count   = "0"
#   launch_type     = "FARGATE"
#   health_check_grace_period_seconds = 30

#   network_configuration {
#     security_groups  = ["${aws_security_group.jenkins.id}"]
#     subnets          = ["${aws_subnet.primary_public_a.id}", "${aws_subnet.primary_public_b.id}"]
#     assign_public_ip = true
#   }

#   load_balancer {
#     target_group_arn = "${aws_alb_target_group.mmpl_tg_1.id}"
#     container_name   = "mmpl_backend-api-staging"
#     container_port   = 80
#   }

#   load_balancer {
#     target_group_arn = "${aws_alb_target_group.mmpl_tg_2.id}"
#     container_name   = "mmpl_backend-api-staging"
#     container_port   = 80
#   }

#   service_registries {
#     registry_arn = "${aws_service_discovery_service.jenkins_sys.arn}"
#     container_name = "jenkins_sys_cont"
#   }

#   # depends_on = [
#   #   aws_alb_listener.jenkins,
#   #   aws_iam_role_policy_attachment.ecs_task_execution_role
#   # ]
# }

## CodeDeploy App
# resource "aws_codedeploy_app" "mmpl-staging" {
#   name = "mmpl-staging"
# }

# resource "aws_codedeploy_deployment_group" "mmpl-staging" {
#   app_name              = "${aws_codedeploy_app.mmpl-staging.name}"
#   deployment_group_name = "mmpl-staging"
#   service_role_arn      = "${aws_iam_role.deploy_service_role.arn}"

#   deployment_style {
#     deployment_option = "WITH_TRAFFIC_CONTROL"
#     deployment_type   = "BLUE_GREEN"
#   }

#   ecs_service {
#     cluster_name = "${aws_ecs_cluster.example.name}"
#     service_name = "${aws_ecs_service.example.name}"
#   }

#   load_balancer_info {
#     target_group_pair_info {
#       prod_traffic_route {
#         listener_arns = ["${aws_alb_listener.mmpl_staging.arn}", "${aws_alb_listener.mmpl_staging_ssl.arn}"]
#       }

#       target_group {
#         name = "${aws_alb_target_group.mmpl_tg_1.name}"
#       }

#       target_group {
#         name = "${aws_alb_target_group.mmpl_tg_2.name}"
#       }
#     }
#   }

#   blue_green_deployment_config {
#     deployment_ready_option {
#       action_on_timeout    = "CONTINUE_DEPLOYMENT"
#     }

#     green_fleet_provisioning_option {
#       action = "DISCOVER_EXISTING"
#     }

#     terminate_blue_instances_on_deployment_success {
#       action = "TERMINATE"
#       termination_wait_time_in_minutes = 5
#     }
#   }
# }

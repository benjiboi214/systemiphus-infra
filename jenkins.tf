# ## Security Groups
# # Traffic to the Jenkins LB should only come from 443 SSL
# resource "aws_security_group" "jenkins_lb" {
#   name        = "sys-jenkins-lb-sg"
#   description = "controls access to the ALB"
#   vpc_id      = "${aws_vpc.primary.id}"

#   ingress {
#     protocol    = "tcp"
#     from_port   = 443
#     to_port     = 443
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     protocol    = "tcp"
#     from_port   = 80
#     to_port     = 80
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     protocol    = "-1"
#     from_port   = 0
#     to_port     = 0
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# # Traffic to the ECS cluster should only come from the ALB
# resource "aws_security_group" "jenkins" {
#   name        = "sys-jenkins-task-sg"
#   description = "allow inbound access from the ALB only"
#   vpc_id      = "${aws_vpc.primary.id}"

#   ingress {
#     protocol        = "tcp"
#     from_port       = "8080"
#     to_port         = "8080"
#     security_groups = ["${aws_security_group.jenkins_lb.id}"]
#   }

#   ingress {
#     protocol        = "tcp"
#     from_port       = "50000"
#     to_port         = "50000"
#     security_groups = ["${aws_security_group.jenkins_slave.id}"]
#   }

#   egress {
#     protocol    = "-1"
#     from_port   = 0
#     to_port     = 0
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# # Traffic for Jenkins slaves can go to 
# # 50000 access to jenkins master
# # 8080 access to jenkins master
# resource "aws_security_group" "jenkins_slave" {
#   name        = "sys-jenkins-slave-sg"
#   description = "Allow port 50000 to the jenkins master sg only"
#   vpc_id      = "${aws_vpc.primary.id}"

#   egress {
#     protocol    = "-1"
#     from_port   = 0
#     to_port     = 0
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     protocol    = "tcp"
#     from_port   = 80
#     to_port     = 80
#     security_groups = ["${aws_security_group.public.id}"]
#   }

#   egress {
#     protocol    = "tcp"
#     from_port   = 443
#     to_port     = 443
#     security_groups = ["${aws_security_group.public.id}"]
#   }
# }

# ## Load Balancer
# resource "aws_alb" "jenkins" {
#   name            = "alb-sys-jenkins"
#   subnets         = ["${aws_subnet.primary_public_a.id}", "${aws_subnet.primary_public_b.id}"]
#   security_groups = ["${aws_security_group.jenkins_lb.id}"]
# }

# resource "aws_alb_target_group" "jenkins" {
#   name        = "alb-tg-sys-jenkins"
#   port        = 80
#   protocol    = "HTTP"
#   vpc_id      = "${aws_vpc.primary.id}"
#   target_type = "ip"

#   health_check {
#     healthy_threshold   = "5"
#     interval            = "60"
#     protocol            = "HTTP"
#     port                = "8080"
#     matcher             = "200"
#     timeout             = "5"
#     path                = "/login"
#     unhealthy_threshold = "10"
#   }
# }

# # Redirect all traffic from the ALB to the target group
# resource "aws_lb_listener" "jenkins_ssl" {
#   load_balancer_arn = "${aws_alb.jenkins.id}"
#   port              = "443"
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = "${var.jenkins_domain_ssl_cert_arn}"

#   default_action {
#     type             = "forward"
#     target_group_arn = "${aws_alb_target_group.jenkins.id}"
#   }
# }

# # Redirect all HTTP requests to SSL
# resource "aws_alb_listener" "jenkins" {
#   load_balancer_arn = "${aws_alb.jenkins.id}"
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type = "redirect"

#     redirect {
#       port        = "443"
#       protocol    = "HTTPS"
#       status_code = "HTTP_301"
#     }
#   }
# }

# # Add DNS for the Load Balancer
# resource "aws_route53_record" "jenkins" {
#   zone_id = "${aws_route53_zone.public_dns.zone_id}"
#   name    = "jenkins.systemiphus.com"
#   type    = "A"

#   alias {
#     name                   = "${aws_alb.jenkins.dns_name}"
#     zone_id                = "${aws_alb.jenkins.zone_id}"
#     evaluate_target_health = true
#   }
# }

# ## Service Discovery
# resource "aws_service_discovery_private_dns_namespace" "systemiphus" {
#   name        = "systemiphus.int"
#   description = "The Internal systemiphus DNS namespace"
#   vpc         = "${aws_vpc.primary.id}"
# }

# resource "aws_service_discovery_service" "jenkins_sys" {
#   name = "jenkins_sys_sd"

#   dns_config {
#     namespace_id = "${aws_service_discovery_private_dns_namespace.systemiphus.id}"

#     dns_records {
#       ttl  = 10
#       type = "A"
#     }

#     routing_policy = "MULTIVALUE"
#   }
# }

# ## Service
# # Jenkins Master
# resource "aws_ecs_service" "jenkins" {
#   name            = "jenkins-service"
#   cluster         = "${aws_ecs_cluster.systemiphus.id}"
#   task_definition = "${var.jenkins_master_task_definition_arn}"
#   # desired_count   = "${var.jenkins_count}"
#   desired_count   = "0"
#   launch_type     = "FARGATE"
#   health_check_grace_period_seconds = 30

#   network_configuration {
#     security_groups  = ["${aws_security_group.jenkins.id}"]
#     subnets          = ["${aws_subnet.primary_public_a.id}", "${aws_subnet.primary_public_b.id}"]
#     assign_public_ip = true
#   }

#   load_balancer {
#     target_group_arn = "${aws_alb_target_group.jenkins.id}"
#     container_name   = "jenkins_sys_cont"
#     container_port   = 8080
#   }

#   service_registries {
#     registry_arn = "${aws_service_discovery_service.jenkins_sys.arn}"
#     container_name = "jenkins_sys_cont"
#   }
# }
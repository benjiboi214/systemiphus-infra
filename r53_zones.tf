resource "aws_route53_zone" "systemiphus_private_dns" {
  name = "int.systemiphus.com"
}

resource "aws_route53_zone" "systemiphus_public_dns" {
  name = "systemiphus.com"
}
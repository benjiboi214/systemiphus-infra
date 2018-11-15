resource "aws_route53_zone" "systemiphus_private_dns" {
  name = "internal-systemiphus.com"

  vpc {
    vpc_id = "${aws_vpc.systemiphus.id}"
  }
}

resource "aws_route53_zone" "systemiphus_public_dns" {
  name = "systemiphus.com"
}
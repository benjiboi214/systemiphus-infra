resource "aws_route53_record" "bastion" {
  zone_id = "${aws_route53_zone.systemiphus_public_dns.zone_id}"
  name    = "bastion.systemiphus.com"
  type    = "A"
  ttl     = "300"
  records = ["${aws_eip.systemiphus_nat_ip.public_ip}"]
}

resource "aws_route53_record" "jenkins" {
  zone_id = "${aws_route53_zone.systemiphus_private_dns.zone_id}"
  name    = "jenkins.systemiphus.com"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.jenkins_host.private_ip}"]
}

resource "aws_route53_record" "ansible_awx" {
  zone_id = "${aws_route53_zone.systemiphus_private_dns.zone_id}"
  name    = "ansible_awx.systemiphus.com"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.tower_host.private_ip}"]
}
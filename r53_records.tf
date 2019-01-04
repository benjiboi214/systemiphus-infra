resource "aws_route53_record" "bastion" {
  zone_id = "${aws_route53_zone.systemiphus_public_dns.zone_id}"
  name    = "bastion.systemiphus.com"
  type    = "A"
  ttl     = "300"
  records = ["${aws_eip.systemiphus_bastion_ip.public_ip}"]
}

resource "aws_route53_record" "nat" {
  zone_id = "${aws_route53_zone.systemiphus_public_dns.zone_id}"
  name    = "nat.systemiphus.com"
  type    = "A"
  ttl     = "300"
  records = ["${aws_eip.systemiphus_nat_ip.public_ip}"]
}

resource "aws_route53_record" "systemiphus_mx_records" {
  zone_id = "${aws_route53_zone.systemiphus_public_dns.zone_id}"
  name    = ""
  type    = "MX"
  ttl     = "300"
  records = "${var.protonmail_mx_records}"
}

resource "aws_route53_record" "systemiphus_txt_records" {
  zone_id = "${aws_route53_zone.systemiphus_public_dns.zone_id}"
  name    = ""
  type    = "TXT"
  ttl     = "300"
  records = "${var.protonmail_txt_records}"
}

resource "aws_route53_record" "systemiphus_dmarc_txt_records" {
  zone_id = "${aws_route53_zone.systemiphus_public_dns.zone_id}"
  name    = "_dmarc.systemiphus.com"
  type    = "TXT"
  ttl     = "300"
  records = "${var.protonmail_dmarc_txt_records}"
}

resource "aws_route53_record" "systemiphus_dkim_txt_records" {
  zone_id = "${aws_route53_zone.systemiphus_public_dns.zone_id}"
  name    = "protonmail._domainkey.systemiphus.com"
  type    = "TXT"
  ttl     = "300"
  records = "${var.protonmail_dkim_txt_records}"
}

resource "aws_route53_record" "int" {
  zone_id = "${aws_route53_zone.systemiphus_public_dns.zone_id}"
  name    = "int"
  type    = "NS"
  ttl     = "300"
  records = ["${aws_route53_zone.systemiphus_private_dns.name_servers}"]
}

# resource "aws_route53_record" "jenkins" {
#   zone_id = "${aws_route53_zone.systemiphus_private_dns.zone_id}"
#   name    = "jenkins"
#   type    = "A"
#   ttl     = "300"
#   records = ["${aws_instance.jenkins_host.private_ip}"]
# }

resource "aws_route53_record" "ansible_awx" {
  zone_id = "${aws_route53_zone.systemiphus_private_dns.zone_id}"
  name    = "awx"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.awx_host.private_ip}"]
}

resource "aws_route53_record" "bastion_int" {
  zone_id = "${aws_route53_zone.systemiphus_private_dns.zone_id}"
  name    = "bastion"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.bastion_host.private_ip}"]
}

resource "aws_route53_record" "nat_int" {
  zone_id = "${aws_route53_zone.systemiphus_private_dns.zone_id}"
  name    = "nat"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.nat_host.private_ip}"]
}
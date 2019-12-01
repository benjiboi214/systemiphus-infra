## Variables
variable "protonmail_mx_records" {
    type = "list"
}
variable "protonmail_txt_records" {
    type = "list"
}
variable "protonmail_dmarc_txt_records" {
    type = "list"
}
variable "protonmail_dkim_txt_records" {
    type = "list"
}

# Internal DNS
resource "aws_route53_zone" "internal_dns" {
  name = "int.systemiphus.com"
}

# Public DNS
resource "aws_route53_zone" "public_dns" {
  name = "systemiphus.com"
}

resource "aws_route53_record" "vpn" {
  zone_id = "${aws_route53_zone.public_dns.zone_id}"
  name    = "vpn.systemiphus.com"
  type    = "A"
  ttl     = "300"
  records = ["${aws_eip.vpn.public_ip}"]
}

output "vpn_instance_public_dns" {
  value = "${aws_route53_record.vpn.name}"
}

# MMPL DNS
resource "aws_route53_zone" "mmpl_dns" {
  name = "mmpl.systemiphus.com"
}

resource "aws_route53_record" "mmpl" {
  zone_id = "${aws_route53_zone.public_dns.zone_id}"
  name    = "mmpl"
  type    = "NS"
  ttl     = "300"
  records = "${aws_route53_zone.mmpl_dns.name_servers}"
}


# Email Settings (Proton Mail)
resource "aws_route53_record" "mx_records" {
  zone_id = "${aws_route53_zone.public_dns.zone_id}"
  name    = ""
  type    = "MX"
  ttl     = "300"
  records = "${var.protonmail_mx_records}"
}

resource "aws_route53_record" "txt_records" {
  zone_id = "${aws_route53_zone.public_dns.zone_id}"
  name    = ""
  type    = "TXT"
  ttl     = "300"
  records = "${var.protonmail_txt_records}"
}

resource "aws_route53_record" "dmarc_txt_records" {
  zone_id = "${aws_route53_zone.public_dns.zone_id}"
  name    = "_dmarc.systemiphus.com"
  type    = "TXT"
  ttl     = "300"
  records = "${var.protonmail_dmarc_txt_records}"
}

resource "aws_route53_record" "dkim_txt_records" {
  zone_id = "${aws_route53_zone.public_dns.zone_id}"
  name    = "protonmail._domainkey.systemiphus.com"
  type    = "TXT"
  ttl     = "300"
  records = "${var.protonmail_dkim_txt_records}"
}
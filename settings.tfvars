# Gerneal Settings
aws_region = "ap-southeast-2"

# Network Settings
primary_cidr = "10.1.0.0/16"
az_1 = "ap-southeast-2b"
az_2 = "ap-southeast-2c"

# VPN/Nat Instance
vpn_instance_size = "t2.nano"

# Jenkins Instance
jenkins_instance_size = "t2.micro"

# MMPL Instances
mmpl_instance_size = "t2.nano"

# Instances
ubuntu_1604_ami = "ami-09d9316fe73403e7b"
key_name = "terraform-provisioner"

# DNS Settings
protonmail_mx_records = ["10 mail.protonmail.ch", "20 mailsec.protonmail.ch"]
protonmail_txt_records = ["protonmail-verification=3f1b177096a522e847f39de1be485179715d5025", "v=spf1 include:_spf.protonmail.ch mx ~all"]
protonmail_dmarc_txt_records = ["v=DMARC1; p=none; rua=mailto:ben.elliot@systemiphus.com"]
protonmail_dkim_txt_records = ["v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCX/Es3jq2pV5BYQsoNErzwwI+m8yq58t4I0iuuddu57rvHEcp2RORgxXFOTCH8G32J7AAPAjs8BAkTNuBbmdUudKJiQkrIr5gbvQ3NrsIDd/jNGRcR14G94TJgrgae+WN4O9lBYEohBTK6iPfm9zipQ4bpnA5My+8UFAcuRQZ8pwIDAQAB"]
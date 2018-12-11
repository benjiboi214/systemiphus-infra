// Actually provide the terraform variable content here.

# VPC Settings
systemiphus_base_cidr_block = "10.0.0.0/8"

# Amazon region and AZ settings
systemiphus_aws_region = "ap-southeast-2"
systemiphus_aws_az = "ap-southeast-2b"

# Set the preexisting keyname in AWS
systemiphus_ssh_keyname = "systemiphus_ultimate_access"

# Bastion/NAT host tier size
systemiphus_bastion_host_size = "t2.micro"

# For now, only the 0 map (Sydney) is in use.
# In future we should be able to deploy cross region resources using this to expand the cidr block
systemiphus_region_map = {
    ap-southeast-2 = 0 # Sydney
}

# NAT Instance AMI name
systemiphus_openvpn_ami = "ami-7777b515"

# Product code for CentOS
systemiphus_centos_product_code = "aw0evgkw8e5c1q413zgy5pjce"
systemiphus_ubuntu_ami = "ami-03932cb7d3a1a69af"

# Proton mail settings for systemiphus domain
protonmail_mx_records = ["10 mail.protonmail.ch", "20 mailsec.protonmail.ch"]
protonmail_txt_records = ["protonmail-verification=3f1b177096a522e847f39de1be485179715d5025", "v=spf1 include:_spf.protonmail.ch mx ~all"]
protonmail_dmarc_txt_records = ["v=DMARC1; p=none; rua=mailto:ben.elliot@systemiphus.com"]
protonmail_dkim_txt_records = ["v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCX/Es3jq2pV5BYQsoNErzwwI+m8yq58t4I0iuuddu57rvHEcp2RORgxXFOTCH8G32J7AAPAjs8BAkTNuBbmdUudKJiQkrIr5gbvQ3NrsIDd/jNGRcR14G94TJgrgae+WN4O9lBYEohBTK6iPfm9zipQ4bpnA5My+8UFAcuRQZ8pwIDAQAB"]

belliot_current_public_ip = ["121.208.45.46/32"]
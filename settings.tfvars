# Gerneal Settings
aws_region = "ap-southeast-2"

# Network Settings
primary_cidr = "10.10.0.0/16"
az_1 = "ap-southeast-2b"
az_2 = "ap-southeast-2c"

# VPN/Nat Instance
vpn_instance_size = "t2.nano"

# Instances
ubuntu_1604_ami = "ami-09d9316fe73403e7b"
key_name = "terraform-provisioner"

# DNS Settings
protonmail_mx_records = ["10 mail.protonmail.ch", "20 mailsec.protonmail.ch"]
protonmail_txt_records = ["protonmail-verification=3f1b177096a522e847f39de1be485179715d5025", "v=spf1 include:_spf.protonmail.ch mx ~all"]
protonmail_dmarc_txt_records = ["v=DMARC1; p=none; rua=mailto:ben.elliot@systemiphus.com"]
protonmail_dkim_txt_records = ["v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCX/Es3jq2pV5BYQsoNErzwwI+m8yq58t4I0iuuddu57rvHEcp2RORgxXFOTCH8G32J7AAPAjs8BAkTNuBbmdUudKJiQkrIr5gbvQ3NrsIDd/jNGRcR14G94TJgrgae+WN4O9lBYEohBTK6iPfm9zipQ4bpnA5My+8UFAcuRQZ8pwIDAQAB"]


mailgun_spf_txt_record = ["v=spf1 include:mailgun.org ~all"]
mailgun_krs_txt_record = ["k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCe9aanZgAb3jmg6s40ypXVMs9osn0kX1b6gg4iUAqU4JS57U47hHCUFaP6A5YuuI0KCKyoJyN5dAo4ebAjkK2BHlykauO4mFTMvWW8JetTyHDHtZn6KFx/Wu4T6ucPGJZ7e6sdI0Cjz+NEoaF2PZYVNOjC2tFw2/kcOD3n0FmzUQIDAQAB"]
mailgun_mx_record = ["10 mxa.mailgun.org", "10 mxb.mailgun.org"]
mailgun_cname_record = ["mailgun.org"]

# ECS Settings
ecs_task_execution_role_name = "ecsTaskExecution-systemiphus"
jenkins_master_task_definition_arn = "arn:aws:ecs:ap-southeast-2:413514076128:task-definition/jenkins_sys_td:6"
jenkins_domain_ssl_cert_arn = "arn:aws:acm:ap-southeast-2:413514076128:certificate/5d75bb44-6de8-4f1c-b42e-3ef97beb3952"
mmpl_domain_ssl_cert_arn = "arn:aws:acm:ap-southeast-2:413514076128:certificate/dabd6209-f87d-49b2-a292-58b6f3068942"
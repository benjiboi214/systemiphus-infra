// Actually provide the terraform variable content here.

# VPC Settings
systemiphus_base_cidr_block = "10.0.0.0/8"

# Amazon region and AZ settings
systemiphus_aws_region = "ap-southeast-2"
systemiphus_aws_az = "ap-southeast-2b"

# For now, only the 0 map (Sydney) is in use.
# In future we should be able to deploy cross region resources using this to expand the cidr block
systemiphus_region_map = {
    ap-southeast-2 = 0 # Sydney
}
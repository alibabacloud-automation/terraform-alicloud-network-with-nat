#ECS
system_disk_size = 60

# VPC
vpc_name        = "update-tf-vpc-name"
vpc_description = "update-tf-vpc-description"
vpc_tags = {
  Name = "UPDATE-VPC"
}
tags = {
  Name = "UPDATE-NETWORK-WITH-NAT"
}

# Vswitch
vswitch_name        = "update-tf-vswitch-name"
vswitch_description = "update-tf-vswitch-description"
vswitch_tags = {
  Name = "UPDATE-VSWITCH"
}

#variables for nat gateway
nat_name          = "update-tf-nat-name"
nat_specification = "Middle"
nat_description   = "update-tf-description"
nat_period        = 2

# common bandwodth package
bandwidth_package_name = "update-tf-bandwidth-package-name"
cbp_bandwidth          = 10

# New EIP parameters
eip_bandwidth = 10
eip_period    = 2
eip_tags = {
  Name = "UPDATE-EIP"
}

# Dnat Entries
name          = "update-tf-testacc-dnat"
ip_protocol   = "udp"
external_port = "90"
internal_port = "9090"
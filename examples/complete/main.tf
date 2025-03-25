data "alicloud_zones" "default" {
}

data "alicloud_images" "default" {
  name_regex = "ubuntu_18"
}

data "alicloud_instance_types" "default" {
  availability_zone    = data.alicloud_zones.default.zones[0].id
  cpu_core_count       = 2
  memory_size          = 8
  instance_type_family = "ecs.g6"
}

resource "alicloud_eip_association" "snat" {
  count         = 5
  allocation_id = module.temp_snat_eip.this_eip_id[count.index]
  instance_id   = module.nat_eip_snat.this_nat_gateway_id
}

module "security_group" {
  source  = "alibaba/security-group/alicloud"
  version = "2.4.0"

  vpc_id = module.vpc.this_vpc_id
}

module "ecs_instance" {
  source  = "alibaba/ecs-instance/alicloud"
  version = "2.12.0"

  number_of_instances = 6

  instance_type               = data.alicloud_instance_types.default.instance_types[0].id
  image_id                    = data.alicloud_images.default.images[0].id
  vswitch_ids                 = module.vpc.this_vswitch_ids
  security_group_ids          = [module.security_group.this_security_group_id]
  associate_public_ip_address = false
  system_disk_category        = "cloud_ssd"
  system_disk_size            = var.system_disk_size
}

module "temp_snat_eip" {
  source  = "terraform-alicloud-modules/eip/alicloud"
  version = "2.0.0"

  create = true

  number_of_eips       = 5
  bandwidth            = var.eip_bandwidth
  internet_charge_type = "PayByTraffic"
  instance_charge_type = "PostPaid"
  period               = var.eip_period
  isp                  = "BGP"
}

#####################
# Create vpc, nat-gateway and bind eip and add snat, dnat
#####################
module "vpc" {
  source = "../.."

  # module vpc
  use_existing_vpc = false
  create_vpc       = true

  vpc_name        = var.vpc_name
  vpc_cidr        = "172.16.0.0/16"
  vpc_description = var.vpc_description
  vpc_tags        = var.vpc_tags
  tags            = var.tags

  vswitch_cidrs = [
    cidrsubnet("172.16.0.0/12", 8, 8), cidrsubnet("172.16.0.0/12", 8, 9), cidrsubnet("172.16.0.0/12", 8, 10),
    cidrsubnet("172.16.0.0/12", 8, 11), cidrsubnet("172.16.0.0/12", 8, 12), cidrsubnet("172.16.0.0/12", 8, 15)
  ]
  availability_zones  = [data.alicloud_zones.default.zones[0].id]
  use_num_suffix      = true
  vswitch_name        = var.vswitch_name
  vswitch_description = var.vswitch_description
  vswitch_tags        = var.vswitch_tags

  # nat-gateway
  create_nat = false

  # snat
  number_of_snat_eip = 0
  create_snat        = false

  # dnat
  number_of_dnat_eip = 0
  create_dnat        = false

}

module "nat_eip_snat" {
  source = "../.."

  # module vpc
  create_vpc       = false
  use_existing_vpc = true

  # nat-gateway
  create_nat = true

  existing_vpc_id      = module.vpc.this_vpc_id
  vswitch_id           = module.vpc.this_vswitch_ids[0]
  nat_name             = var.nat_name
  nat_type             = var.nat_type
  nat_specification    = var.nat_specification
  nat_description      = var.nat_description
  payment_type         = "PayAsYouGo"
  internet_charge_type = "PayByLcu"
  nat_period           = var.nat_period

  # common bandwodth package
  bandwidth_package_name   = var.bandwidth_package_name
  cbp_bandwidth            = var.cbp_bandwidth
  cbp_internet_charge_type = "PayByBandwidth"
  cbp_ratio                = 100

  # snat_eip
  number_of_snat_eip       = 1
  eip_name                 = var.eip_name
  use_num_suffix           = false
  eip_bandwidth            = var.eip_bandwidth
  eip_internet_charge_type = "PayByTraffic"
  eip_instance_charge_type = "PostPaid"
  eip_period               = var.eip_period
  eip_isp                  = "BGP"
  eip_tags                 = var.eip_tags

  # snat
  create_snat = true

  snat_ips    = module.temp_snat_eip.this_eip_address
  vswitch_ids = [module.vpc.this_vswitch_ids[0]]
  snat_with_source_cidrs = [
    {
      name         = var.eip_name
      source_cidrs = [format("%s/32", module.ecs_instance.this_private_ip[1])]
      snat_ip      = module.temp_snat_eip.this_eip_address[1]
    }
  ]
  snat_with_instance_ids = [
    {
      name         = var.eip_name
      instance_ids = [module.ecs_instance.this_instance_id[2]]
      snat_ip      = module.temp_snat_eip.this_eip_address[2]
    }
  ]

  # dnat
  number_of_dnat_eip = 0
  create_dnat        = false

}

module "eip_dnat" {
  source = "../.."

  # module vpc
  create_vpc       = false
  use_existing_vpc = true

  # nat-gateway
  create_nat = false

  # common bandwodth package
  bandwidth_package_name   = var.bandwidth_package_name
  cbp_bandwidth            = var.cbp_bandwidth
  cbp_internet_charge_type = "PayByBandwidth"
  cbp_ratio                = 100

  # snat_eip
  number_of_snat_eip = 0

  # snat
  create_snat = false

  # dnat_eip
  number_of_dnat_eip = 1

  eip_name                 = var.eip_name
  use_num_suffix           = false
  eip_bandwidth            = var.eip_bandwidth
  eip_internet_charge_type = "PayByTraffic"
  eip_instance_charge_type = "PostPaid"
  eip_period               = var.eip_period
  eip_isp                  = "BGP"
  eip_tags                 = var.eip_tags

  #alicloud_eip_association
  dnat_eip_association_instance_id = module.nat_eip_snat.this_nat_gateway_id

  # dnat
  create_dnat = true

  dnat_table_id = module.nat_eip_snat.this_forward_table_id
  dnat_entries = [
    {
      name          = var.name
      ip_protocol   = var.ip_protocol
      external_port = var.external_port
      internal_port = var.internal_port
      internal_ip   = module.ecs_instance.this_private_ip[5]
    }
  ]

}

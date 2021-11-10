provider "alicloud" {
  profile                 = var.profile != "" ? var.profile : null
  shared_credentials_file = var.shared_credentials_file != "" ? var.shared_credentials_file : null
  region                  = var.region != "" ? var.region : null
  skip_region_validation  = var.skip_region_validation
  configuration_source    = "terraform-alicloud-modules/network-with-nat"
}

#########################
# vpc module
#########################
locals {
  create_vpc = var.use_existing_vpc ? false : var.create_vpc
}

module "vpc" {
  source                  = "alibaba/vpc/alicloud"
  profile                 = var.profile != "" ? var.profile : null
  shared_credentials_file = var.shared_credentials_file != "" ? var.shared_credentials_file : null
  region                  = var.region != "" ? var.region : null
  skip_region_validation  = var.skip_region_validation

  vpc_id          = var.existing_vpc_id
  create          = local.create_vpc
  vpc_name        = var.vpc_name
  vpc_cidr        = var.vpc_cidr
  vpc_description = "A new VPC created by Terrafrom module terraform-alicloud-network-with-nat."
  vpc_tags        = merge(var.vpc_tags, var.tags)

  vswitch_cidrs       = var.vswitch_cidrs
  availability_zones  = var.availability_zones
  use_num_suffix      = true
  vswitch_name        = var.vswitch_name
  vswitch_description = "New VSwitch created by Terrafrom module terraform-alicloud-network-with-nat."
  vswitch_tags        = merge(var.vswitch_tags, var.tags)
}

#########################
# nat-gateway
#########################
locals {
  vpc_id              = var.existing_vpc_id != "" ? var.existing_vpc_id : module.vpc.vpc_id
  number_of_eip       = var.number_of_dnat_eip + var.number_of_snat_eip
  create_snat_eip     = var.number_of_snat_eip > 0 ? true : false
  create_dnat_eip     = var.number_of_dnat_eip > 0 ? true : false
}

resource "alicloud_nat_gateway" "this" {
  count                = var.create_nat ? 1 : 0
  vpc_id               = local.vpc_id
  name                 = var.nat_name
  specification        = var.nat_specification
  description          = "A Nat Gateway created by terraform-alicloud-network-with-nat."
  instance_charge_type = var.nat_instance_charge_type
  period               = var.nat_period
  nat_type             = var.nat_type
  vswitch_id           = module.vpc.this_vswitch_ids[0]
}

#########################
# common bandwodth package
#########################
resource "alicloud_common_bandwidth_package" "default" {
  count                = local.number_of_eip > 0 ? 1 : 0
  name                 = "tf_cbp"
  bandwidth            = var.cbp_bandwidth
  internet_charge_type = var.cbp_internet_charge_type
  ratio                = var.cbp_ratio
}

#########################
# snat
#########################
module "eip_snat" {
  source                  = "terraform-alicloud-modules/eip/alicloud"
  profile                 = var.profile != "" ? var.profile : null
  shared_credentials_file = var.shared_credentials_file != "" ? var.shared_credentials_file : null
  region                  = var.region != "" ? var.region : null
  skip_region_validation  = var.skip_region_validation

  create               = local.create_snat_eip
  number_of_eips       = var.number_of_snat_eip
  name                 = var.eip_name
  use_num_suffix       = true
  bandwidth            = var.eip_bandwidth
  internet_charge_type = var.eip_internet_charge_type
  instance_charge_type = var.eip_instance_charge_type
  period               = var.eip_period
  tags = merge(
    {
      InstanceType = "snat"
    }, var.eip_tags
  )
  isp = var.eip_isp
}

resource "alicloud_eip_association" "snat" {
  count         = local.create_snat_eip && var.create_nat ? var.number_of_snat_eip : 0
  allocation_id = module.eip_snat.this_eip_id[count.index]
  instance_id   = alicloud_nat_gateway.this.0.id
}

resource "alicloud_common_bandwidth_package_attachment" "snat" {
  count                = var.number_of_snat_eip > 0 ? var.number_of_snat_eip : 0
  bandwidth_package_id = alicloud_common_bandwidth_package.default.0.id
  instance_id          = module.eip_snat.this_eip_id[count.index]
}

locals {
  snat_with_vswitch_ids = flatten(
    [
      for idx, obj in module.eip_snat.this_eip_address : {
        vswitch_ids = module.vpc.this_vswitch_ids[idx]
        snat_ip     = obj
      }
    ]
  )
}

module "snat" {
  source                  = "terraform-alicloud-modules/snat/alicloud"
  profile                 = var.profile != "" ? var.profile : null
  shared_credentials_file = var.shared_credentials_file != "" ? var.shared_credentials_file : null
  region                  = var.region != "" ? var.region : null
  skip_region_validation  = var.skip_region_validation

  create         = var.create_snat
  snat_ips       = var.snat_ips
  snat_table_id  = concat(alicloud_nat_gateway.this.*.snat_table_ids, [""])[0]

  snat_with_vswitch_ids          = local.snat_with_vswitch_ids
  snat_with_source_cidrs         = var.snat_with_source_cidrs
  snat_with_instance_ids         = var.snat_with_instance_ids
  computed_snat_with_source_cidr = var.computed_snat_with_source_cidr
  computed_snat_with_vswitch_id  = var.computed_snat_with_vswitch_id
}


#########################
# snat
#########################
module "eip_dnat" {
  source                  = "terraform-alicloud-modules/eip/alicloud"
  profile                 = var.profile != "" ? var.profile : null
  shared_credentials_file = var.shared_credentials_file != "" ? var.shared_credentials_file : null
  region                  = var.region != "" ? var.region : null
  skip_region_validation  = var.skip_region_validation

  create               = local.create_dnat_eip
  number_of_eips       = var.number_of_dnat_eip
  name                 = var.eip_name
  use_num_suffix       = true
  bandwidth            = var.eip_bandwidth
  internet_charge_type = var.eip_internet_charge_type
  instance_charge_type = var.eip_instance_charge_type
  period               = var.eip_period
  tags = merge(
    {
      InstanceType = "dnat"
    }, var.eip_tags
  )
  isp = var.eip_isp
}

resource "alicloud_eip_association" "dnat" {
  count         = local.create_dnat_eip && var.create_nat ? var.number_of_dnat_eip : 0
  allocation_id = module.eip_dnat.this_eip_id[count.index]
  instance_id   = alicloud_nat_gateway.this.0.id
}

resource "alicloud_common_bandwidth_package_attachment" "dnat" {
  count                = var.number_of_dnat_eip > 0 ? var.number_of_dnat_eip : 0
  bandwidth_package_id = alicloud_common_bandwidth_package.default.0.id
  instance_id          = module.eip_dnat.this_eip_id[count.index]
}

locals {
  entries = flatten(
    [
      for idx, obj in var.dnat_entries : {
        name          = lookup(obj, "name", "")
        ip_protocol   = lookup(obj, "ip_protocol", "")
        external_port = lookup(obj, "external_port", "")
        internal_port = lookup(obj, "internal_port", "")
        internal_ip   = lookup(obj, "internal_ip", "")
        external_ip   = module.eip_dnat.this_eip_address[idx]
      }
    ]
  )
}

module "dnat" {
  source                  = "terraform-alicloud-modules/dnat/alicloud"
  profile                 = var.profile != "" ? var.profile : null
  shared_credentials_file = var.shared_credentials_file != "" ? var.shared_credentials_file : null
  region                  = var.region != "" ? var.region : null
  skip_region_validation  = var.skip_region_validation

  create         = var.create_dnat
  dnat_table_id  = concat(alicloud_nat_gateway.this.*.forward_table_ids, [""])[0]
  entries        = local.entries
  external_ip    = var.dnat_external_ip
}
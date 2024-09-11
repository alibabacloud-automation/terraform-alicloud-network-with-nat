#################
#  module VPC
#################
output "this_vpc_id" {
  description = "The ID of the VPC."
  value       = module.vpc.this_vpc_id
}

output "this_vpc_name" {
  description = "The VPC name."
  value       = module.vpc.this_vpc_name
}

output "this_vpc_tags" {
  description = "The tags of the VPC."
  value       = module.vpc.this_vpc_tags
}

output "this_availability_zones" {
  description = "List of availability zones in which vswitches launched."
  value       = module.vpc.this_availability_zones
}

output "this_vpc_cidr_block" {
  description = "The VPC cidr block."
  value       = module.vpc.this_vpc_cidr_block
}

output "this_vswitch_ids" {
  description = "List of IDs of vswitch."
  value       = module.vpc.this_vswitch_ids
}

output "this_vswitch_name" {
  description = "The name of vswitch."
  value       = module.vpc.this_vswitch_names
}

output "this_vswitch_tags" {
  description = "List of IDs of vswitch."
  value       = module.vpc.this_vswitch_tags
}

output "this_vswitch_cidr_block" {
  description = "The vswitch cidr block."
  value       = module.vpc.this_vswitch_cidr_blocks
}

#################
# nat_gateway
#################
output "this_nat_gateway_id" {
  description = "The nat gateway id."
  value       = concat(alicloud_nat_gateway.this[*].id, [""])[0]
}

output "this_forward_table_id" {
  description = "The forward table id in this nat gateway. Seem as 'this_dnat_table_id'."
  value       = concat(alicloud_nat_gateway.this[*].forward_table_ids, [""])[0]
}

output "this_snat_table_id" {
  description = "The snat table id in this nat gateway."
  value       = concat(alicloud_nat_gateway.this[*].snat_table_ids, [""])[0]
}

output "this_nat_gateway_name" {
  description = "The nat gateway name."
  value       = concat(alicloud_nat_gateway.this[*].name, [""])[0]
}

output "this_nat_gateway_spec" {
  description = "The nat gateway spec."
  value       = concat(alicloud_nat_gateway.this[*].spec, [""])[0]
}

output "this_nat_gateway_description" {
  description = "The nat gateway id."
  value       = concat(alicloud_nat_gateway.this[*].description, [""])[0]
}

#################
# eip_snat
#################
output "this_eip_snat_ids" {
  description = "The id of new eips."
  value       = module.eip_snat.this_eip_id
}

output "this_eip_snat_ips" {
  description = "The id of new eip addresses."
  value       = module.eip_snat.this_eip_address
}

#################
# eip_dnat
#################
output "this_eip_dnat_ids" {
  description = "The id of new eips."
  value       = module.eip_dnat.this_eip_id
}

output "this_eip_dnat_ips" {
  description = "The id of new eip addresses."
  value       = module.eip_dnat.this_eip_address
}

#################
# module snat
#################
output "this_snat_entry_id_of_snat_with_source_cidrs" {
  description = "List of ids creating by snat_with_source_cidrs."
  value       = module.snat.this_snat_entry_id_of_snat_with_source_cidrs
}

output "this_snat_entry_name_of_snat_with_source_cidrs" {
  description = "List of names creating by snat_with_source_cidrs."
  value       = module.snat.this_snat_entry_name_of_snat_with_source_cidrs
}

output "this_snat_entry_id_of_snat_with_vswitch_ids" {
  description = "List of ids creating by snat_with_vswitch_ids."
  value       = module.snat.this_snat_entry_id_of_snat_with_vswitch_ids
}

output "this_snat_entry_name_of_snat_with_vswitch_ids" {
  description = "List of names creating by snat_with_vswitch_ids."
  value       = module.snat.this_snat_entry_name_of_snat_with_vswitch_ids
}

output "this_snat_entry_id_of_snat_with_instance_ids" {
  description = "List of ids creating by snat_with_instance_ids."
  value       = module.snat.this_snat_entry_id_of_snat_with_instance_ids
}

output "this_snat_entry_name_of_snat_with_instance_ids" {
  description = "List of names creating by snat_with_instance_ids."
  value       = module.snat.this_snat_entry_name_of_snat_with_instance_ids
}
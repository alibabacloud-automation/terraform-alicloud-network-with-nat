
variable "nat_instance_charge_type" {
  description = "(Deprecated from version 1.2.0) The charge type of the nat gateway. Choices are 'PostPaid' and 'PrePaid'."
  type        = string
  default     = "PostPaid"
}

#################
# VPC
#################
variable "create_vpc" {
  description = "Whether to create vpc. If false, you can specify an existing vpc by setting 'existing_vpc_id'."
  type        = bool
  default     = true
}

variable "use_existing_vpc" {
  description = "The vpc id used to launch several vswitches. If set, the 'create_vpc' will be ignored."
  type        = bool
  default     = false
}

variable "existing_vpc_id" {
  description = "The vpc id used to launch several vswitches."
  type        = string
  default     = ""
}

variable "vpc_name" {
  description = "The vpc name used to launch a new vpc."
  type        = string
  default     = ""
}

variable "vpc_cidr" {
  description = "The cidr block used to launch a new vpc."
  type        = string
  default     = "172.16.0.0/12"
}

variable "vpc_description" {
  description = "The vpc description used to launch a new vpc."
  type        = string
  default     = ""
}

variable "vpc_tags" {
  description = "The tags used to launch a new vpc."
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "The common tags will apply to all of resources."
  type        = map(string)
  default     = {}
}

#################
# Vswitch
#################
variable "vswitch_cidrs" {
  description = "List of cidr blocks used to launch several new vswitches. If not set, there is no new vswitches will be created."
  type        = list(string)
  default     = []
}

variable "availability_zones" {
  description = "List available zones to launch several VSwitches."
  type        = list(string)
  default     = []
}

variable "use_num_suffix" {
  description = "Always append numerical suffix(like 001, 002 and so on) to vswitch name, even if the length of `vswitch_cidrs` is 1"
  type        = bool
  default     = false
}

variable "vswitch_name" {
  description = "The vswitch name prefix used to launch several new vswitches."
  type        = string
  default     = ""
}

variable "vswitch_description" {
  description = "The vswitch description used to launch several new vswitch."
  type        = string
  default     = ""
}

variable "vswitch_tags" {
  description = "The tags used to launch serveral vswitches."
  type        = map(string)
  default     = {}
}

########################
#variables for nat gateway
########################
variable "create_nat" {
  description = "Whether to create nat gateway."
  type        = bool
  default     = true
}

variable "vswitch_id" {
  description = "ID of the vswitch where to create nat gateway."
  type        = string
  default     = ""
}

variable "nat_name" {
  description = "Name of a new nat gateway."
  type        = string
  default     = ""
}

variable "nat_type" {
  description = "The type of NAT gateway."
  type        = string
  default     = "Enhanced"
}

variable "nat_specification" {
  description = "The specification of nat gateway."
  type        = string
  default     = "Small"
}

variable "nat_description" {
  description = "The description of nat gateway."
  type        = string
  default     = ""
}

variable "payment_type" {
  description = "The billing method of the NAT gateway."
  type        = string
  default     = "PayAsYouGo"
}

variable "internet_charge_type" {
  description = "The internet charge type."
  type        = string
  default     = "PayByLcu"
}

variable "nat_period" {
  description = "The charge duration of the PrePaid nat gateway, in month."
  type        = number
  default     = 1
}

#########################
# common bandwodth package
#########################
variable "bandwidth_package_name" {
  description = "The name of the common bandwidth package."
  type        = string
  default     = ""
}

variable "cbp_bandwidth" {
  description = "The bandwidth of the common bandwidth package, in Mbps."
  type        = number
  default     = 5
}

variable "cbp_internet_charge_type" {
  description = "The billing method of the common bandwidth package. Valid values are 'PayByBandwidth' and 'PayBy95' and 'PayByTraffic'. 'PayBy95' is pay by classic 95th percentile pricing. International Account doesn't supports 'PayByBandwidth' and 'PayBy95'. Default to 'PayByTraffic'."
  type        = string
  default     = "PayByBandwidth"
}

variable "cbp_ratio" {
  description = "Ratio of the common bandwidth package."
  type        = number
  default     = 100
}

variable "number_of_snat_eip" {
  description = "Number of EIP instance used to bind with this Snat."
  type        = number
  default     = 0
}

variable "number_of_dnat_eip" {
  description = "Number of EIP instance used to bind with this Dnat."
  type        = number
  default     = 0
}

variable "eip_name" {
  description = "Name to be used on all eip as prefix. Default to 'TF-EIP-for-Nat'. The final default name would be TF-EIP-for-Nat001, TF-EIP-for-Nat002 and so on."
  type        = string
  default     = ""
}

variable "eip_bandwidth" {
  description = "Maximum bandwidth to the elastic public network, measured in Mbps (Mega bit per second)."
  type        = number
  default     = 5
}

variable "eip_internet_charge_type" {
  description = "Internet charge type of the EIP, Valid values are 'PayByBandwidth', 'PayByTraffic'. "
  type        = string
  default     = "PayByTraffic"
}

variable "eip_instance_charge_type" {
  description = "Elastic IP instance charge type."
  type        = string
  default     = "PostPaid"
}

variable "eip_period" {
  description = "The duration that you will buy the EIP, in month."
  type        = number
  default     = 1
}

variable "eip_isp" {
  description = "The line type of the Elastic IP instance."
  type        = string
  default     = ""
}

variable "eip_tags" {
  description = "A mapping of tags to assign to the EIP instance resource."
  type        = map(string)
  default     = {}
}

variable "dnat_eip_association_instance_id" {
  description = "The ID of the ECS or SLB instance or Nat Gateway or NetworkInterface or HaVip."
  type        = string
  default     = ""
}

#################
# Snat Entries
#################
variable "create_snat" {
  description = "Whether to create snat entries. If true, the 'snat_with_source_cidrs' or 'snat_with_instance_ids' should be set."
  type        = bool
  default     = false
}

variable "snat_ips" {
  description = "The public ip addresses to use on all snat entries."
  type        = list(string)
  default     = []
}

variable "vswitch_ids" {
  description = "A list of virtual switch IDs to launch in."
  type        = list(string)
  default     = []
}

variable "snat_with_source_cidrs" {
  description = "List of snat entries to create by cidr blocks. Each item valid keys: 'source_cidrs'(required, using comma joinor to set multi cidrs), 'snat_ip'(if not, use root parameter 'snat_ips', using comma joinor to set multi ips), 'name'(if not, will return one automatically)."
  type = list(object({
    name         = optional(string, null)
    source_cidrs = optional(list(string), [])
    snat_ip      = optional(string, null)
  }))
  default = []
}

variable "snat_with_instance_ids" {
  description = "List of snat entries to create by ecs instance ids. Each item valid keys: 'instance_ids'(required, using comma joinor to set multi instance ids), 'snat_ip'(if not, use root parameter 'snat_ips', using comma joinor to set multi ips), 'name'(if not, will return one automatically)."
  type = list(object({
    name         = optional(string, null)
    instance_ids = optional(list(string), [])
    snat_ip      = optional(string, null)
  }))
  default = []
}

#################
# Dnat Entries
#################
variable "create_dnat" {
  description = "Whether to create dnat entries. If true, the 'entries' should be set."
  type        = bool
  default     = false
}

variable "dnat_table_id" {
  description = "The value can get from alicloud_nat_gateway Attributes 'forward_table_ids'."
  type        = string
  default     = ""
}

variable "dnat_entries" {
  description = "A list of entries to create. Each item valid keys: 'name'(default to a string with prefix 'tf-dnat-entry' and numerical suffix), 'ip_protocol'(default to 'any'), 'external_ip'(if not, use root parameter 'external_ip'), 'external_port'(default to 'any'), 'internal_ip'(required), 'internal_port'(default to the 'external_port')."
  type        = list(map(string))
  default     = []
}


#ECS
variable "system_disk_size" {
  description = "Size of the system disk, measured in GiB."
  type        = number
  default     = 50
}

# VPC
variable "vpc_name" {
  description = "The vpc name used to launch a new vpc."
  type        = string
  default     = "tf-vpc-name"
}

variable "vpc_description" {
  description = "The vpc description used to launch a new vpc."
  type        = string
  default     = "tf-vpc-description"
}

variable "vpc_tags" {
  description = "The tags used to launch a new vpc."
  type        = map(string)
  default = {
    Name = "VPC"
  }
}

variable "tags" {
  description = "The common tags will apply to all of resources."
  type        = map(string)
  default = {
    Name = "NETWORK-WITH-NAT"
  }
}

# Vswitch
variable "vswitch_name" {
  description = "The vswitch name prefix used to launch several new vswitches."
  type        = string
  default     = "tf-vswitch-name"
}

variable "vswitch_description" {
  description = "The vswitch description used to launch several new vswitch."
  type        = string
  default     = "tf-vswitch-description"
}

variable "vswitch_tags" {
  description = "The tags used to launch serveral vswitches."
  type        = map(string)
  default = {
    Name = "VSWITCH"
  }
}

#variables for nat gateway
variable "nat_name" {
  description = "Name of a new nat gateway."
  type        = string
  default     = "tf-nat-name"
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
  default     = "tf-nat-description"
}

variable "nat_period" {
  description = "The charge duration of the PrePaid nat gateway, in month."
  type        = number
  default     = 1
}

# common bandwodth package
variable "bandwidth_package_name" {
  description = "The name of the common bandwidth package."
  type        = string
  default     = "tf-bandwidth-package-name"
}

variable "cbp_bandwidth" {
  description = "The bandwidth of the common bandwidth package, in Mbps."
  type        = number
  default     = 5
}

# New EIP parameters
variable "eip_name" {
  description = "Name to be used on all eip as prefix. Default to 'TF-EIP-for-Nat'. The final default name would be TF-EIP-for-Nat001, TF-EIP-for-Nat002 and so on."
  type        = string
  default     = "tf-eip-name"
}

variable "eip_bandwidth" {
  description = "Maximum bandwidth to the elastic public network, measured in Mbps (Mega bit per second)."
  type        = number
  default     = 5
}

variable "eip_period" {
  description = "The duration that you will buy the EIP, in month."
  type        = number
  default     = 1
}

variable "eip_tags" {
  description = "A mapping of tags to assign to the EIP instance resource."
  type        = map(string)
  default = {
    Name = "EIP"
  }
}

# Dnat Entries
variable "name" {
  description = "The name of forward entry."
  type        = string
  default     = "tf-testacc-dnat"
}

variable "ip_protocol" {
  description = "The ip protocol, valid value is tcp|udp|any."
  type        = string
  default     = "tcp"
}

variable "external_port" {
  description = "The external port, valid value is 1~65535|any."
  type        = string
  default     = "80"
}

variable "internal_port" {
  description = "The internal port, valid value is 1~65535|any."
  type        = string
  default     = "8080"
}
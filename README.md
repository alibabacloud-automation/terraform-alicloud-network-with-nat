Terraform Module for building a VPC and Nat gateway network environment on Alibaba Cloud.
terraform-alicloud-network-and-nat
==================================

English | [简体中文](https://github.com/terraform-alicloud-modules/terraform-alicloud-network-with-nat/blob/master/README-CN.md)

Terraform Module for building a VPC and Nat gateway network environment on Alibaba Cloud and bind EIP, add SNAT and DNAT.

These types of resources are supported:

* [VPC](https://www.terraform.io/docs/providers/alicloud/r/vpc.html)
* [Nat Gateway](https://www.terraform.io/docs/providers/alicloud/r/nat_gateway.html)
* [EIP](https://www.terraform.io/docs/providers/alicloud/r/eip.html)
* [EIP Association](https://www.terraform.io/docs/providers/alicloud/r/eip_association.html)
* [Forward Entry](https://www.terraform.io/docs/providers/alicloud/r/forward_entry.html)
* [Snat Entry](https://www.terraform.io/docs/providers/alicloud/r/snat.html)

## Terraform versions

The Module requires Terraform 0.12 and Terraform Provider AliCloud 1.71.1+.

## Usage

```hcl
// Create VPC and nat gateway
module "vpc-nat" {
  source     = "terraform-alicloud-modules/network-with-nat/alicloud"
  region     = "cn-hangzhou"
  profile    = "Your-Profile-Name"

  create_vpc = true
  vpc_name   = "my-env-vpc"
  vpc_cidr   = "10.10.0.0/16"

  availability_zones = ["cn-hangzhou-e", "cn-hangzhou-f", "cn-hangzhou-g"]
  vswitch_cidrs      = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]

  vpc_tags = {
    Owner       = "user"
    Environment = "staging"
    Name        = "complete"
  }

  vswitch_tags = {
    Project  = "Secret"
    Endpoint = "true"
  }

  // common bandwidth package
  cbp_bandwidth = 10
  cbp_ratio     = 100

  // nat_gateway
  create_nat = true
  nat_name   = "nat-gateway-foo"

  // eip
  create_eip = true
  eip_name   = "eip-nat-foo"

  // create eip, snat and bind eip with vswitch_cidrs
  create_snat        = true
  number_of_snat_eip = 3

  // create eip, snat and bind eip with instance
  create_dnat        = true
  number_of_dnat_eip = 1
  dnat_entries = [
    {
      name          = "dnat-443-8443"
      ip_protocol   = "tcp"
      external_port = "443"
      internal_port = "8443"
      internal_ip   = "10.10.1.24"
    }
  ]
}
```

## Examples

* [complete](https://github.com/terraform-alicloud-modules/terraform-alicloud-network-with-nat/tree/master/examples/complete)

## Notes
* This module using AccessKey and SecretKey are from `profile` and `shared_credentials_file`.
If you have not set them yet, please install [aliyun-cli](https://github.com/aliyun/aliyun-cli#installation) and configure it.

Submit Issues
-------------
If you have any problems when using this module, please opening a [provider issue](https://github.com/terraform-providers/terraform-provider-alicloud/issues/new) and let us know.

**Note:** There does not recommend to open an issue on this repo.

Authors
-------
Created and maintained by Zhou qilin(z17810666992@163.com), He Guimin(@xiaozhu36, heguimin36@163.com).

License
----
Apache 2 Licensed. See LICENSE for full details.

Reference
---------
* [Terraform-Provider-Alicloud Github](https://github.com/terraform-providers/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://www.terraform.io/docs/providers/alicloud/index.html)

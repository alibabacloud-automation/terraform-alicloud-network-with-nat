terraform-alicloud-network-and-nat
==================================

本 Terraform Module 用于在阿里云上构建 VPC 和 Nat 网关网络环境并绑定 EIP，添加 SNAT 和 DNAT 条目。

本 Module 支持创建以下资源:

* [VPC](https://www.terraform.io/docs/providers/alicloud/r/vpc.html)
* [Nat Gateway](https://www.terraform.io/docs/providers/alicloud/r/nat_gateway.html)
* [EIP](https://www.terraform.io/docs/providers/alicloud/r/eip.html)
* [EIP Association](https://www.terraform.io/docs/providers/alicloud/r/eip_association.html)
* [Forward Entry](https://www.terraform.io/docs/providers/alicloud/r/forward_entry.html)
* [Snat Entry](https://www.terraform.io/docs/providers/alicloud/r/snat.html)

## Terraform 版本

本模板要求使用版本 Terraform 0.12 和 阿里云 Provider 1.71.1+。

## 用法

```hcl
// Create VPC, nat gateway and bind eip.
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

## 示例

* [完整示例](https://github.com/terraform-alicloud-modules/terraform-alicloud-network-with-nat/tree/master/examples/complete)

## 注意事项

* 本 Module 使用的 AccessKey 和 SecretKey 可以直接从 `profile` 和 `shared_credentials_file` 中获取。如果未设置，可通过下载安装 [aliyun-cli](https://github.com/aliyun/aliyun-cli#installation) 后进行配置。

提交问题
-------
如果在使用该 Terraform Module 的过程中有任何问题，可以直接创建一个 [Provider Issue](https://github.com/terraform-providers/terraform-provider-alicloud/issues/new)，我们将根据问题描述提供解决方案。

**注意:** 不建议在该 Module 仓库中直接提交 Issue。

作者
-------
Created and maintained by Alibaba Cloud Terraform Team(terraform@alibabacloud.com)

参考
----
Apache 2 Licensed. See LICENSE for full details.

许可
---------
* [Terraform-Provider-Alicloud Github](https://github.com/terraform-providers/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://www.terraform.io/docs/providers/alicloud/index.html)

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


## 用法

```hcl
// Create VPC, nat gateway and bind eip.
module "vpc-nat" {
  source     = "terraform-alicloud-modules/network-with-nat/alicloud"

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

本Module从版本v1.1.0开始已经移除掉如下的 provider 的显示设置：

```hcl
provider "alicloud" {
  profile                 = var.profile != "" ? var.profile : null
  shared_credentials_file = var.shared_credentials_file != "" ? var.shared_credentials_file : null
  region                  = var.region != "" ? var.region : null
  skip_region_validation  = var.skip_region_validation
  configuration_source    = "terraform-alicloud-modules/network-with-nat"
}
```

如果你依然想在Module中使用这个 provider 配置，你可以在调用Module的时候，指定一个特定的版本，比如 1.0.0:

```hcl
module "vpc-nat" {
  source  = "terraform-alicloud-modules/network-with-nat/alicloud"
  version     = "1.0.0"
  region      = "cn-hangzhou"
  profile     = "Your-Profile-Name"
  create_vpc = true
  vpc_name   = "my-env-vpc"
  // ...
}
```

如果你想对正在使用中的Module升级到 1.1.0 或者更高的版本，那么你可以在模板中显示定义一个系统过Region的provider：
```hcl
provider "alicloud" {
  region  = "cn-hangzhou"
  profile = "Your-Profile-Name"
}
module "vpc-nat" {
  source  = "terraform-alicloud-modules/network-with-nat/alicloud"
  create_vpc = true
  vpc_name   = "my-env-vpc"
  // ...
}
```
或者，如果你是多Region部署，你可以利用 `alias` 定义多个 provider，并在Module中显示指定这个provider：

```hcl
provider "alicloud" {
  region  = "cn-hangzhou"
  profile = "Your-Profile-Name"
  alias   = "hz"
}
module "vpc-nat" {
  source  = "terraform-alicloud-modules/network-with-nat/alicloud"
  providers = {
    alicloud = alicloud.hz
  }
  create_vpc = true
  vpc_name   = "my-env-vpc"
  // ...
}
```

定义完provider之后，运行命令 `terraform init` 和 `terraform apply` 来让这个provider生效即可。

更多provider的使用细节，请移步[How to use provider in the module](https://www.terraform.io/docs/language/modules/develop/providers.html#passing-providers-explicitly)

## Terraform 版本

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.0 |
| <a name="requirement_alicloud"></a> [alicloud](#requirement\_alicloud) | >= 1.71.1+ |

提交问题
-------
如果在使用该 Terraform Module 的过程中有任何问题，可以直接创建一个 [Provider Issue](https://github.com/terraform-providers/terraform-provider-alicloud/issues/new)，我们将根据问题描述提供解决方案。

**注意:** 不建议在该 Module 仓库中直接提交 Issue。

作者
-------
Created and maintained by Zhou qilin(z17810666992@163.com), He Guimin(@xiaozhu36, heguimin36@163.com).

参考
----
Apache 2 Licensed. See LICENSE for full details.

许可
---------
* [Terraform-Provider-Alicloud Github](https://github.com/terraform-providers/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://www.terraform.io/docs/providers/alicloud/index.html)

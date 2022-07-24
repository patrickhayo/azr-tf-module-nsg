# azr-tf-module-nsg

[Terraform](https://www.terraform.io) Module to create **Network Securitz Group (NSG)** in Azure

<!-- BEGIN_TF_DOCS -->
## Prerequisites

- [Terraform](https://releases.hashicorp.com/terraform/) v0.12+

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >=2.36.0 |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=0.14.9 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=2.36.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_network_security_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_subnet_network_security_group_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | (Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) Specifies the name of the network security group. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the resource group in which to create the network security group. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_rules"></a> [rules](#input\_rules) | n/a | <pre>list(object({<br>    name        = string<br>    description = string<br>    protocol    = string<br>    access      = string<br>    priority    = string<br>    direction   = string<br><br>    source = object({<br>      port_range                     = string<br>      port_ranges                    = list(string)<br>      address_prefix                 = string<br>      address_prefixes               = list(string)<br>      application_security_group_ids = list(string)<br>    })<br><br>    destination = object({<br>      port_range                     = string<br>      port_ranges                    = list(string)<br>      address_prefix                 = string<br>      address_prefixes               = list(string)<br>      application_security_group_ids = list(string)<br>    })<br>  }))</pre> | n/a | yes |
| <a name="input_associate_subnet_id"></a> [associate\_subnet\_id](#input\_associate\_subnet\_id) | (Optional) The ID of the Subnet. Changing this forces a new resource to be created. | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) Specifies the tags of the network security group | `map` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nsg_id"></a> [nsg\_id](#output\_nsg\_id) | n/a |
| <a name="output_nsg_name"></a> [nsg\_name](#output\_nsg\_name) | n/a |

## Example

```hcl
resource "azurerm_resource_group" "this" {
  name     = uuid()
  location = "westeurope"
}

module "nsg" {
  source              = "./modules"
  name                = "nsg-example"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  associate_subnet_id = "mySubnetId"
  rules = [
    {
      name        = "AllowRemoteAzureBastionSubnetInbound"
      description = "Allow SSH and RDP from AzureBastionSubnet Inbound."
      protocol    = "*"
      access      = "Allow"
      priority    = 100
      direction   = "Inbound"
      source = {
        port_range                     = "*"
        port_ranges                    = null
        address_prefix                 = "*"
        address_prefixes               = null
        application_security_group_ids = null
      }
      destination = {
        port_range                     = null
        port_ranges                    = ["22", "3389"]
        address_prefix                 = "*"
        address_prefixes               = null
        application_security_group_ids = null
      }
    },
    {
      name        = "DenyRemoteAnyInbound"
      description = "Deny SSH and RDP from Any Inbound."
      protocol    = "*"
      access      = "Allow"
      priority    = 200
      direction   = "Inbound"
      source = {
        port_range                     = "*"
        port_ranges                    = null
        address_prefix                 = "*"
        address_prefixes               = null
        application_security_group_ids = null
      }
      destination = {
        port_range                     = null
        port_ranges                    = ["22", "3389"]
        address_prefix                 = "*"
        address_prefixes               = null
        application_security_group_ids = null
      }
    }
  ]
}
```


<!-- END_TF_DOCS -->
## Authors

Originally created by [Patrick Hayo](http://github.com/patrickhayo)

## License

[MIT](LICENSE) License - Copyright (c) 2022 by the Author.

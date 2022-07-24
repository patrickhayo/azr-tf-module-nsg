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

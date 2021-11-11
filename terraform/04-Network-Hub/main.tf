#############
# RESOURCES #
#############

# Resource Group for Hub
# ----------------------

resource "azurerm_resource_group" "rg" {
  name     = "${var.hub_prefix}-rg"
  location = var.location
}

#############
## OUTPUTS ##
#############
# These outputs are used by later deployments
output "hub_vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "hub_rg_location" {
  value = var.location
}

output "hub_rg_name" {
  value = azurerm_resource_group.rg.name
}





output "vnet_id" {
  description = "The ID of the Virtual Network."
  value       = azurerm_virtual_network.vnet.id
}

output "subnet_ids" {
  description = "The IDs of the Subnets."
  value       = { for s in azurerm_subnet.subnet : s.name => s.id }
}
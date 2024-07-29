variable "vnet_name" {
  description = "The name of the Virtual Network."
  type        = string
}

variable "vnet_address_space" {
  description = "The address space of the Virtual Network."
  type        = list(string)
}

variable "location" {
  description = "The location/region where the resources will be created."
  type        = string
}

variable "subnets" {
  description = "List of subnets to create."
  type = list(object({
    name           = string
    address_prefix = list(string)
  }))
}

variable "resource_group_name" {
  description = "The name of the Resource Group."
  type        = string
}
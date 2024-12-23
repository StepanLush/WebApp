variable "vnet_name" {
  description = "Имя виртуальной сети"
  type        = string
}

variable "location" {
  description = "Локация ресурсов"
  type        = string
}

variable "resource_group_name" {
  description = "Имя resource group"
  type        = string
}

variable "address_space" {
  description = "Диапазон адресов для виртуальной сети"
  type        = list(string)
}

variable "subnets" {
  description = "Список подсетей с их конфигурациями"
  type = list(object({
    name           = string
    address_prefix = string
    security_rules = list(object({
      name                    = string
      protocol                = string
      destination_port_ranges = list(string)
      priority                = number
    }))
  }))
}

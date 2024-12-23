variable "vm_name" {
  description = "Имя виртуальной машины"
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

variable "subnet_id" {
  description = "ID подсети"
  type        = string
}

variable "vm_size" {
  description = "Размер виртуальной машины"
  type        = string
  default     = "Standard_B1s"
}

variable "admin_username" {
  description = "Имя администратора"
  type        = string
}

variable "admin_password" {
  description = "Пароль администратора"
  type        = string
  sensitive   = true
}

variable "ssh_public_key" {
  description = "Public SSH key for the VM"
  type        = string
}

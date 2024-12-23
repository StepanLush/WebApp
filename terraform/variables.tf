variable "resource_group_name" {
  description = "Имя группы ресурсов"
  type        = string
}

variable "location" {
  description = "Регион Azure"
  type        = string
  default     = "East US"
}

variable "vnet_name" {
  description = "Имя виртуальной сети"
  type        = string
}

variable "admin_username" {
  description = "Имя администратора для виртуальных машин"
  type        = string
}

variable "admin_password" {
  description = "Пароль администратора для виртуальных машин"
  type        = string
  sensitive   = true
}

variable "db_admin_username" {
  description = "Имя администратора базы данных"
  type        = string
}

variable "db_admin_password" {
  description = "Пароль администратора базы данных"
  type        = string
  sensitive   = true
}

variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "api_key" {
  description = "API ключ для backend"
  type        = string
}

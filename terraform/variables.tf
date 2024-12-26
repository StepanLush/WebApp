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

variable "ARM_SUBSCRIPTION_ID" {
  description = "Azure Subscription ID"
  type        = string
}

variable "ARM_CLIENT_ID" {
  description = "Azure Client ID"
  type        = string
}

variable "ARM_CLIENT_SECRET" {
  description = "Azure Client Secret"
  type        = string
}

variable "ARM_TENANT_ID" {
  description = "Azure Tenant ID"
  type        = string
}

variable "api_key" {
  description = "API ключ для backend"
  type        = string
}

variable "ssh_public_key" {
  description = "The public SSH key to be added to the VM"
  type        = string
}

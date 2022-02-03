variable "resource_group_name" {
  description = "The resource group where the resources should be created."
  default = "resourcegroupname"
}

variable "location" {
  default     = "eastus"
  description = "The azure datacenter location where the resources should be created."
}

variable "function_app_name" {
  description = "The name for the function app. Without environment naming."
  default = "testfunctionapp2"
}

variable "function_version" {
  default     = "beta"
  description = "The runtime version the function app should have."
}

variable "account_replication_type" {
  default     = "LRS"
  description = "The Storage Account replication type. See azurerm_storage_account module for posible values."
}

variable "app_settings" {
  type        = map(string)  
  description = "Application settings to insert on creating the function app. Following updates will be ignored, and has to be set manually. Updates done on application deploy or in portal will not affect terraform state file."
  default     = {FUNCTIONS_WORKER_RUNTIME = "dotnet"} 
}

variable "tags" {
  description = "A tomap of tags to add to all resources"
  type        = map(string)
  default = {a = "b"
            project = "image-resizing"}
}

variable "environment" {
  type = string
  default     = "lab"
  description = "The environment where the infrastructure is deployed."
}

variable "release" {
  type = string
  default     = "2022-01-10"
  description = "The release the deploy is based on."
}

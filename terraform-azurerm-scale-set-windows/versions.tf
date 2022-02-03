terraform {
  required_version = ">= 0.13"

  required_providers {
    azurerm = ">= 2.44.0"
  }
}

provider "azurerm" {
  features {
    virtual_machine_scale_set {
      roll_instances_when_required = false
    }
  }
}

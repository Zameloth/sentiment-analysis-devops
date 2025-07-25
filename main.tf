// main.tf
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.0.0"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"
  admin_enabled       = true
}

resource "azurerm_service_plan" "asp" {
  name                = var.app_service_plan_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "B1"
  os_type             = "Linux"
}

resource "azurerm_linux_web_app" "webapp" {
  name                = var.webapp_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    application_stack {
      docker_image     = "${azurerm_container_registry.acr.login_server}/${var.image_name}"
      docker_image_tag = var.image_tag
    }
  }

  app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
    DOCKER_REGISTRY_SERVER_URL          = "https://${azurerm_container_registry.acr.login_server}"
    DOCKER_REGISTRY_SERVER_USERNAME     = azurerm_container_registry.acr.admin_username
    DOCKER_REGISTRY_SERVER_PASSWORD     = azurerm_container_registry.acr.admin_password
    WEBSITES_PORT                       = "8000"  # Ajustez selon le port de votre app
  }
}

output "webapp_default_hostname" {
  description = "URL de l'application hébergée"
  value       = azurerm_linux_web_app.webapp.default_hostname
}

// variables.tf
variable "resource_group_name" {
  description = "Nom du groupe de ressources"
  type        = string
  default     = "sentimentApi"
}

variable "location" {
  description = "Région Azure"
  type        = string
  default     = "West Europe"
}

variable "acr_name" {
  description = "Nom de l'Azure Container Registry"
  type        = string
  default     = "4iabdSentimentACR"
}

variable "app_service_plan_name" {
  description = "Nom du plan App Service"
  type        = string
  default     = "4iabdSentimentAPIServicePlan"
}

variable "webapp_name" {
  description = "Nom de l'App Service (Web App)"
  type        = string
  default     = "4iabdSentimentAPIWebApp"
}

variable "image_name" {
  description = "Nom de l'image Docker hébergée dans ACR"
  type        = string
  default     = "4iabdSentimentAPI"
}

variable "image_tag" {
  description = "Tag de l'image Docker (généralement le Build ID)"
  type        = string
  default     = "latest"
}

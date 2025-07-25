# Variables existantes
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

# Nouvelles variables pour les deux services
variable "webapp_name" {
  description = "Nom de base pour les Web Apps"
  type        = string
  default     = "4iabdSentimentAPI"
}

variable "api_image_name" {
  description = "Nom de l'image Docker pour l'API"
  type        = string
  default     = "sentiment-api"
}

variable "model_image_name" {
  description = "Nom de l'image Docker pour le service de modèle"
  type        = string
  default     = "sentiment-model"
}

variable "image_tag" {
  description = "Tag de l'image Docker (généralement le Build ID)"
  type        = string
  default     = "latest"
}

# Variables optionnelles pour la configuration des services
variable "api_cpu_cores" {
  description = "Nombre de cœurs CPU pour l'API"
  type        = string
  default     = "1"
}

variable "api_memory_gb" {
  description = "Mémoire en GB pour l'API"
  type        = string
  default     = "2"
}

variable "model_cpu_cores" {
  description = "Nombre de cœurs CPU pour le service de modèle"
  type        = string
  default     = "2"
}

variable "model_memory_gb" {
  description = "Mémoire en GB pour le service de modèle"
  type        = string
  default     = "4"
}

# Variables pour la configuration de la sécurité
variable "enable_https_only" {
  description = "Forcer HTTPS uniquement"
  type        = bool
  default     = true
}

variable "allowed_origins" {
  description = "Liste des origines autorisées pour CORS"
  type        = list(string)
  default     = []
}

# Outputs pour les URLs des services
output "api_webapp_url" {
  description = "URL de l'API"
  value       = "https://${azurerm_linux_web_app.api_webapp.default_hostname}"
}

output "model_webapp_url" {
  description = "URL du service de modèle"
  value       = "https://${azurerm_linux_web_app.model_webapp.default_hostname}"
}

output "acr_login_server" {
  description = "URL du serveur de connexion ACR"
  value       = azurerm_container_registry.acr.login_server
}
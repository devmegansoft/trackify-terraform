variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "environment" {
  type = string
}

variable "service_name" {
  type = string
}

variable "container_image" {
  type = string
}

variable "container_port" {
  type    = number
  default = 8080
}

variable "ingress" {
  type    = string
  default = "INGRESS_TRAFFIC_ALL"
}

variable "cpu" {
  type    = string
  default = "1"
}

variable "memory" {
  type    = string
  default = "512Mi"
}

variable "min_instances" {
  type    = number
  default = 0
}

variable "max_instances" {
  type    = number
  default = 5
}

variable "env_vars" {
  type    = map(string)
  default = {}
}

variable "labels" {
  type    = map(string)
  default = {}
}

variable "allow_unauthenticated" {
  type    = bool
  default = false
}

variable "grant_artifact_registry_reader" {
  type    = bool
  default = true
}

variable "grant_pubsub_publisher" {
  type    = bool
  default = false
}

variable "grant_pubsub_subscriber" {
  type    = bool
  default = false
}

variable "grant_cloud_sql_client" {
  type    = bool
  default = false
}

variable "cloud_sql_connection_names" {
  description = "Cloud SQL instance connection names for the Cloud Run connector"
  type        = list(string)
  default     = []
}

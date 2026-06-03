variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "environment" {
  type    = string
  default = "qa"
}

variable "artifact_registry_repository" {
  type    = string
  default = "timesheet-portal"
}

variable "terraform_state_bucket" {
  type    = string
  default = "ivory-cycle-466320-r8-terraform-state"
}

variable "manage_state_bucket" {
  type    = bool
  default = false
}

variable "labels" {
  type = map(string)
  default = {
    managed_by = "terraform"
  }
}

# --- Cloud SQL (optional per environment) ---

variable "cloud_sql_enabled" {
  type    = bool
  default = false
}

variable "cloud_sql_instance_name" {
  type    = string
  default = "timesheet-portal-qa"
}

variable "cloud_sql_database_name" {
  type    = string
  default = "timesheetdb"
}

variable "cloud_sql_tier" {
  type    = string
  default = "db-f1-micro"
}

variable "cloud_sql_user" {
  type    = string
  default = "postgres"
}

variable "cloud_sql_password" {
  type      = string
  sensitive = true
  default   = "CHANGE_ME"
}

# --- Fallback DB URL when Cloud SQL module is disabled ---

variable "spring_datasource_url" {
  type    = string
  default = "jdbc:postgresql://YOUR_DB_HOST:5432/timesheetdb"
}


module "cloud_sql" {
  count  = var.cloud_sql_enabled ? 1 : 0
  source = "../../modules/cloud_sql"

  project_id    = var.project_id
  region        = var.region
  instance_name = var.cloud_sql_instance_name
  database_name = var.cloud_sql_database_name
  tier          = var.cloud_sql_tier
  user_name     = var.cloud_sql_user
  user_password = var.cloud_sql_password

  labels = local.default_labels

  depends_on = [google_project_service.required_apis]
}

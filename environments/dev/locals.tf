locals {
  image = "${var.region}-docker.pkg.dev/${var.project_id}/${var.artifact_registry_repository}"

  default_labels = merge(var.labels, {
    environment = var.environment
  })

  # JDBC via Cloud SQL Auth Proxy socket (Cloud Run + Cloud SQL connector)
  cloud_sql_jdbc_url = var.cloud_sql_enabled ? (
    "jdbc:postgresql:///${var.cloud_sql_database_name}?cloudSqlInstance=${module.cloud_sql[0].connection_name}&socketFactory=com.google.cloud.sql.postgres.SocketFactory"
  ) : var.spring_datasource_url

  timesheet_db_password = var.cloud_sql_enabled ? var.cloud_sql_password : "CHANGE_ME"
}

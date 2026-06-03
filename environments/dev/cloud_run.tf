# All Cloud Run microservices for this environment.
# To deploy: change container_image tag → commit → merge → terraform apply.

locals {
  timesheet_service_enabled          = true
  approval_pubsub_consumer_enabled   = false
  approval_service_enabled           = false
  project_service_enabled            = false
  user_service_enabled               = false
  notification_service_enabled       = false
  reporting_service_enabled          = false

  timesheet_cloud_sql_connections = var.cloud_sql_enabled ? [module.cloud_sql[0].connection_name] : []
}

# ------------------------------------------------------------------------------
# timesheet-service (HTTP API)
# ------------------------------------------------------------------------------

module "timesheet_service" {
  count  = local.timesheet_service_enabled ? 1 : 0
  source = "../../modules/cloud_run"

  project_id  = var.project_id
  region      = var.region
  environment = var.environment

  service_name    = "timesheet-service"
  container_image = "${local.image}/timesheet-service:5fba85b82c28"

  min_instances          = 0
  max_instances          = 3
  allow_unauthenticated  = true
  grant_pubsub_publisher = true
  grant_cloud_sql_client = var.cloud_sql_enabled
  cloud_sql_connection_names = local.timesheet_cloud_sql_connections

  env_vars = {
    SPRING_DATASOURCE_URL      = local.cloud_sql_jdbc_url
    SPRING_DATASOURCE_USERNAME = var.cloud_sql_user
    SPRING_DATASOURCE_PASSWORD = local.timesheet_db_password
    APP_GCP_PUBSUB_ENABLED     = "true"
    APP_GCP_PUBSUB_TOPIC_NAME  = var.pubsub_timesheet_topic_name
  }

  labels = merge(local.default_labels, { app = "timesheet-service" })

  depends_on = [google_project_service.required_apis, module.cloud_sql]
}

# ------------------------------------------------------------------------------
# approval-pubsub-consumer (Pub/Sub worker)
# ------------------------------------------------------------------------------

module "approval_pubsub_consumer" {
  count  = local.approval_pubsub_consumer_enabled ? 1 : 0
  source = "../../modules/cloud_run"

  project_id  = var.project_id
  region      = var.region
  environment = var.environment

  service_name    = "approval-pubsub-consumer"
  container_image = "${local.image}/approval-pubsub-consumer:latest"
  ingress         = "INGRESS_TRAFFIC_INTERNAL_ONLY"

  min_instances           = 1
  max_instances           = 2
  grant_pubsub_subscriber = true

  env_vars = {
    APP_GCP_PUBSUB_ENABLED           = "true"
    APP_GCP_PUBSUB_SUBSCRIPTION_NAME = "approval-timesheet-events-sub"
  }

  labels = merge(local.default_labels, { app = "approval-pubsub-consumer" })

  depends_on = [google_project_service.required_apis]
}

# ------------------------------------------------------------------------------
# approval-service (HTTP API) — set local.approval_service_enabled = true
# ------------------------------------------------------------------------------

module "approval_service" {
  count  = local.approval_service_enabled ? 1 : 0
  source = "../../modules/cloud_run"

  project_id  = var.project_id
  region      = var.region
  environment = var.environment

  service_name    = "approval-service"
  container_image = "${local.image}/approval-service:latest"

  labels = merge(local.default_labels, { app = "approval-service" })

  depends_on = [google_project_service.required_apis]
}

# ------------------------------------------------------------------------------
# project-service
# ------------------------------------------------------------------------------

module "project_service" {
  count  = local.project_service_enabled ? 1 : 0
  source = "../../modules/cloud_run"

  project_id  = var.project_id
  region      = var.region
  environment = var.environment

  service_name    = "project-service"
  container_image = "${local.image}/project-service:latest"

  labels = merge(local.default_labels, { app = "project-service" })

  depends_on = [google_project_service.required_apis]
}

# ------------------------------------------------------------------------------
# user-service
# ------------------------------------------------------------------------------

module "user_service" {
  count  = local.user_service_enabled ? 1 : 0
  source = "../../modules/cloud_run"

  project_id  = var.project_id
  region      = var.region
  environment = var.environment

  service_name    = "user-service"
  container_image = "${local.image}/user-service:latest"

  labels = merge(local.default_labels, { app = "user-service" })

  depends_on = [google_project_service.required_apis]
}

# ------------------------------------------------------------------------------
# notification-service (Pub/Sub worker)
# ------------------------------------------------------------------------------

module "notification_service" {
  count  = local.notification_service_enabled ? 1 : 0
  source = "../../modules/cloud_run"

  project_id  = var.project_id
  region      = var.region
  environment = var.environment

  service_name    = "notification-service"
  container_image = "${local.image}/notification-service:latest"
  ingress         = "INGRESS_TRAFFIC_INTERNAL_ONLY"

  grant_pubsub_subscriber = true

  labels = merge(local.default_labels, { app = "notification-service" })

  depends_on = [google_project_service.required_apis]
}

# ------------------------------------------------------------------------------
# reporting-service (Pub/Sub worker)
# ------------------------------------------------------------------------------

module "reporting_service" {
  count  = local.reporting_service_enabled ? 1 : 0
  source = "../../modules/cloud_run"

  project_id  = var.project_id
  region      = var.region
  environment = var.environment

  service_name    = "reporting-service"
  container_image = "${local.image}/reporting-service:latest"
  ingress         = "INGRESS_TRAFFIC_INTERNAL_ONLY"

  grant_pubsub_subscriber = true

  labels = merge(local.default_labels, { app = "reporting-service" })

  depends_on = [google_project_service.required_apis]
}

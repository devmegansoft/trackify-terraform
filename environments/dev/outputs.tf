output "cloud_run_services" {
  description = "Deployed Cloud Run services and URLs"
  value = merge(
    local.timesheet_service_enabled ? {
      timesheet-service = {
        uri   = module.timesheet_service[0].service_uri
        image = module.timesheet_service[0].container_image
      }
    } : {},
    local.approval_pubsub_consumer_enabled ? {
      approval-pubsub-consumer = {
        uri   = module.approval_pubsub_consumer[0].service_uri
        image = module.approval_pubsub_consumer[0].container_image
      }
    } : {},
    local.approval_service_enabled ? {
      approval-service = {
        uri   = module.approval_service[0].service_uri
        image = module.approval_service[0].container_image
      }
    } : {},
    local.project_service_enabled ? {
      project-service = {
        uri   = module.project_service[0].service_uri
        image = module.project_service[0].container_image
      }
    } : {},
    local.user_service_enabled ? {
      user-service = {
        uri   = module.user_service[0].service_uri
        image = module.user_service[0].container_image
      }
    } : {},
    local.notification_service_enabled ? {
      notification-service = {
        uri   = module.notification_service[0].service_uri
        image = module.notification_service[0].container_image
      }
    } : {},
    local.reporting_service_enabled ? {
      reporting-service = {
        uri   = module.reporting_service[0].service_uri
        image = module.reporting_service[0].container_image
      }
    } : {},
  )
}

output "pubsub_topics" {
  value = module.pubsub.topic_names
}

output "pubsub_subscriptions" {
  value = module.pubsub.subscription_names
}

output "cloud_sql" {
  value = var.cloud_sql_enabled ? {
    connection_name = module.cloud_sql[0].connection_name
    public_ip       = module.cloud_sql[0].public_ip
  } : null
}

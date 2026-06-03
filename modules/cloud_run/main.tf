resource "google_service_account" "runtime" {
  project      = var.project_id
  account_id   = substr("${replace(var.service_name, "_", "-")}-${var.environment}", 0, 30)
  display_name = "Cloud Run — ${var.service_name} (${var.environment})"
}

resource "google_project_iam_member" "artifact_registry_reader" {
  count = var.grant_artifact_registry_reader ? 1 : 0

  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.runtime.email}"
}

resource "google_project_iam_member" "pubsub_publisher" {
  count = var.grant_pubsub_publisher ? 1 : 0

  project = var.project_id
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${google_service_account.runtime.email}"
}

resource "google_project_iam_member" "pubsub_subscriber" {
  count = var.grant_pubsub_subscriber ? 1 : 0

  project = var.project_id
  role    = "roles/pubsub.subscriber"
  member  = "serviceAccount:${google_service_account.runtime.email}"
}

resource "google_project_iam_member" "cloud_sql_client" {
  count = var.grant_cloud_sql_client ? 1 : 0

  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.runtime.email}"
}

resource "google_cloud_run_v2_service" "this" {
  project  = var.project_id
  name     = "${var.service_name}-${var.environment}"
  location = var.region
  ingress  = var.ingress

  labels = var.labels

  template {
    service_account = google_service_account.runtime.email

    scaling {
      min_instance_count = var.min_instances
      max_instance_count = var.max_instances
    }

    dynamic "volumes" {
      for_each = length(var.cloud_sql_connection_names) > 0 ? [1] : []
      content {
        name = "cloudsql"
        cloud_sql_instance {
          instances = var.cloud_sql_connection_names
        }
      }
    }

    containers {
      image = var.container_image

      ports {
        container_port = var.container_port
      }

      resources {
        limits = {
          cpu    = var.cpu
          memory = var.memory
        }
      }

      dynamic "env" {
        for_each = var.env_vars
        content {
          name  = env.key
          value = env.value
        }
      }

      dynamic "volume_mounts" {
        for_each = length(var.cloud_sql_connection_names) > 0 ? [1] : []
        content {
          name       = "cloudsql"
          mount_path = "/cloudsql"
        }
      }

      startup_probe {
        tcp_socket {
          port = var.container_port
        }
        initial_delay_seconds = 20
        timeout_seconds       = 3
        period_seconds        = 10
        failure_threshold     = 6
      }

      liveness_probe {
        tcp_socket {
          port = var.container_port
        }
        initial_delay_seconds = 30
        timeout_seconds       = 3
        period_seconds        = 30
        failure_threshold     = 3
      }
    }
  }

  lifecycle {
    ignore_changes = [client, client_version]
  }

  depends_on = [
    google_project_iam_member.artifact_registry_reader,
  ]
}

resource "google_cloud_run_v2_service_iam_member" "public_invoker" {
  count = var.allow_unauthenticated ? 1 : 0

  project  = var.project_id
  location = var.region
  name     = google_cloud_run_v2_service.this.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

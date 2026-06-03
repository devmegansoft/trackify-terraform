module "pubsub" {
  source = "../../modules/pubsub"

  project_id = var.project_id

  topics = {
    timesheet-events = {}
  }

  subscriptions = {
    approval-timesheet-events-sub = {
      topic = "timesheet-events"
    }
  }

  labels = local.default_labels

  depends_on = [google_project_service.required_apis]
}

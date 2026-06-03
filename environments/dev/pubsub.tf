# Topic may already exist from a prior partial apply or manual creation.
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

import {
  to = module.pubsub.google_pubsub_topic.this["timesheet-events"]
  id = "projects/${var.project_id}/topics/timesheet-events"
}

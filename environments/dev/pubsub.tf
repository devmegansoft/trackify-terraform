# Pub/Sub topics/subscriptions are managed outside Terraform (console/gcloud).
# Set var.pubsub_timesheet_topic_name to match your existing topic.

removed {
  from = module.pubsub.google_pubsub_topic.this["timesheet-events"]

  lifecycle {
    destroy = false
  }
}

removed {
  from = module.pubsub.google_pubsub_subscription.this["approval-timesheet-events-sub"]

  lifecycle {
    destroy = false
  }
}

resource "google_pubsub_topic" "this" {
  for_each = var.topics

  project = var.project_id
  name    = each.key

  labels = var.labels
}

resource "google_pubsub_subscription" "this" {
  for_each = var.subscriptions

  project = var.project_id
  name    = each.key
  topic   = google_pubsub_topic.this[each.value.topic].id

  labels = var.labels
}

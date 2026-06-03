output "topic_ids" {
  value = { for k, v in google_pubsub_topic.this : k => v.id }
}

output "topic_names" {
  value = { for k, v in google_pubsub_topic.this : k => v.name }
}

output "subscription_ids" {
  value = { for k, v in google_pubsub_subscription.this : k => v.id }
}

output "subscription_names" {
  value = { for k, v in google_pubsub_subscription.this : k => v.name }
}

variable "project_id" {
  type = string
}

variable "topics" {
  description = "Map of topic name => optional settings"
  type        = map(any)
  default     = {}
}

variable "subscriptions" {
  description = "Map of subscription name => { topic = topic_key }"
  type        = map(object({
    topic = string
  }))
  default = {}
}

variable "labels" {
  type    = map(string)
  default = {}
}

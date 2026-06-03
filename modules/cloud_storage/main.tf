resource "google_storage_bucket" "this" {
  project  = var.project_id
  name     = var.name
  location = var.location

  uniform_bucket_level_access = true
  force_destroy               = var.force_destroy

  dynamic "versioning" {
    for_each = var.versioning ? [1] : []
    content {
      enabled = true
    }
  }

  labels = var.labels
}

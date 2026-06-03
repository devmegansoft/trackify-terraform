module "terraform_state_bucket" {
  count  = var.manage_state_bucket ? 1 : 0
  source = "../../modules/cloud_storage"

  project_id    = var.project_id
  name          = var.terraform_state_bucket
  location      = var.region
  versioning    = true
  force_destroy = false

  labels = local.default_labels

  depends_on = [google_project_service.required_apis]
}


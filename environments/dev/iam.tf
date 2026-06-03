resource "google_project_iam_member" "cloudbuild_run_admin" {
  count = var.manage_cloudbuild_project_iam ? 1 : 0

  project = var.project_id
  role    = "roles/run.admin"
  member  = "serviceAccount:${data.google_project.current.number}@cloudbuild.gserviceaccount.com"
}

resource "google_project_iam_member" "cloudbuild_sa_user" {
  count = var.manage_cloudbuild_project_iam ? 1 : 0

  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${data.google_project.current.number}@cloudbuild.gserviceaccount.com"
}

resource "google_storage_bucket_iam_member" "cloudbuild_state_admin" {
  bucket = var.terraform_state_bucket
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${data.google_project.current.number}@cloudbuild.gserviceaccount.com"
}

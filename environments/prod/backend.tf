terraform {
  backend "gcs" {
    bucket = "ivory-cycle-466320-r8-terraform-state"
    prefix = "portal/prod"
  }
}


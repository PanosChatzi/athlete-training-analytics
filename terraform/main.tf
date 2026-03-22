terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.24.0"
    }
  }
}

provider "google" {
  credentials = file(var.credentials)
  project     = var.project
  region      = var.region
}

resource "google_storage_bucket" "demo-bucket" {
  name                        = var.gcs_bucket_name
  location                    = var.location
  uniform_bucket_level_access = true
  storage_class               = var.gcs_storage_class

  lifecycle_rule {
    condition {
      # The GCS bucket uses a 1‑day lifecycle rule to auto‑delete objects, since this is demo data.
      age = 1
    }
    action {
      type = "Delete"
    }
  }
  force_destroy = true
}

resource "google_bigquery_dataset" "athlete_training_dataset" {
  dataset_id = var.bq_dataset_name
  location   = var.location

  # Controls dataset wipe on destroy
  delete_contents_on_destroy = true

  lifecycle {
    # Controls whether Terraform is allowed to destroy the resource at all
    prevent_destroy = false
  }
}

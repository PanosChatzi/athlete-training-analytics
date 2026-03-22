variable "credentials" {
  description = "My Credentials"
  default     = "/workspaces/athlete-training-analytics/keys/gcp_creds.json"
}

variable "project" {
  description = "Project"
  default     = "ethereal-bison-491017-d8"
}

variable "region" {
  description = "Region"
  default     = "us-central1"
}

variable "location" {
  description = "Project Location"
  default     = "US"
}

variable "gcs_bucket_name" {
  description = "My Storage Bucket Name"
  default     = "athlete-analytics-terra-bucket"
}

variable "gcs_storage_class" {
  description = "Bucket Storage Class"
  default     = "STANDARD"
}

variable "bq_dataset_name" {
  description = "My BigQuery Dataset Name"
  default     = "athlete_training_dataset"
}

# variable "environment" {
#   type        = string
#   description = "Environment being deployed (dev, test, prod)"
# }

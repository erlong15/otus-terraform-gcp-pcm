terraform {
  backend "gcs" {
    bucket  = "tf-state-ololo"
    prefix  = "terraform/state"
  }    
}

provider "google" {
  credentials = file(var.cred_file_path)
  project = var.project_id
  region  = var.region
}


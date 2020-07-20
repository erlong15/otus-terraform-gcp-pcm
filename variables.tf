variable "region" {
  description = "GCP - Region"
  default     = "europe-north1"
}

variable "zone" {
  description = "GCP - Application zone"
  default     = "europe-north1-a"
}

variable "cred_file_path" {
  description = "GCP - Credentials"
}

variable "project" {
  description = "GCP - Project name"
}

variable "disk_image" {
  description = "GCP - Disk image"
}

variable "public_key_path" {
  description = "Public key path"
}

variable "private_key_path" {
  description = "Private key path"
}

variable "node_count" {
  description = "Node count"
  default = "3"
}

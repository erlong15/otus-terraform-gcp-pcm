

variable region {
  description = "Region"
  default     = "europe-north1"
}

variable zone {
  description = "Application zone"
  default     = "europe-north1-a"
}

variable cred_file_path {
  description = "Credentials for GCP"
}

variable project {
  description = "Project name"
}

variable "public_key_path" {
  description = "Public key"
}

variable "disk_image" {
  description = "Disk iamge "
}

variable "private_key_path" {
  description = "private key path"
}

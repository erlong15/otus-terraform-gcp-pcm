variable "project_id" {
  description = "The project ID to host the cluster in"
  default     =  "ololo-masterclass"
}

variable "cluster_name_suffix" {
  description = "A suffix to append to the default cluster name"
  default     = "ololo"
}

variable "region" {
  description = "The region to host the cluster in"
  default     = "europe-north1"
}

variable "skip_provisioners" {
  type        = bool
  description = "Flag to skip local-exec provisioners"
  default     = false
}

variable "enable_binary_authorization" {
  description = "Enable BinAuthZ Admission controller"
  default     = false
}

variable "cred_file_path" {
  description = "GCP - Credentials"
  default     = "~/.ssh/ololo-masterclass-9dc3ee72050e.json"
}

variable "zones" {
    type = list
    default = ["europe-north1-a", "europe-north1-b", "europe-north1-c"]
}
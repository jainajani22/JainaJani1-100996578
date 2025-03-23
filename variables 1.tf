variable "project_id" {
  description = "GCP Project ID"
  type        = string
  default = "hopeful-seat-439302-r4"
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "GCP Zone"
  type        = string
  default     = "us-central1-a"
}

variable "docker_hub_username" {
  description = "user name"
  type        = string
  default = "cppatel8110"
}

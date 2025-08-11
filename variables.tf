variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Prefix name for resources"
  type        = string
  default     = "image-metadata"
}

variable "enable_thumbnail" {
  description = "If true, Lambda will attempt to create thumbnails (not implemented in this package)."
  type    = bool
  default = false
}

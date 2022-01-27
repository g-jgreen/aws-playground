variable "name" {
  description = "Name of the s3 bucket"
  type        = string
}

variable "environment" {
  description = "Name of the environment"
  type        = string
}

variable "acl" {
  description = "ACL configuration of the bucket (defaults to private)"
  type        = string
  default     = "private"
}

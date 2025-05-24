variable "project_name" {
  default = "dojo-management"
  type    = string
}

variable "project_desc" {
  default = "Dojo Management"
  type    = string
}

variable "region" {
  default = "sa-east-1"
  type    = string
}

variable "lambda_name" {
  type = string
}

variable "source_dir" {
  description = "the path without extension"
  default     = "../app"
  type        = string
}

variable "handler" {
  type = string
}

variable "runtime_version" {
  default = "python3.12"
  type    = string
}

variable "access_s3" {
  default = false
  type    = bool
}

variable "env" {
  default = "stg"
  type    = string
}

variable "routes" {
  type = list(object({
    method    = string
    path_part  = string
  }))
  default = []
}
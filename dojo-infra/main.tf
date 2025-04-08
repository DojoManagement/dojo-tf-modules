provider "aws" {
  region  = var.region
}

terraform {
  backend "s3" {
    bucket   = "dojo-management-tfstate"
    key      = "dojo-infra/${var.project_name}-${var.env}-tfstate"
    region   = "sa-east-1"
    endpoints = {
      s3 = "https://oss.sa-east-1.prod-cloud-ocb.orange-business.com"
    }

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
  }
}
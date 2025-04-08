provider "aws" {
  region  = var.region
}

terraform {
  backend "s3" {
    bucket   = "dojo-management-tfstate"
    key      = "dojo-lambda/dojo-management-tfstate"
    region   = "sa-east-1"
    encrypt  = true
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
  }
}
# Dojo Lambda ![MAINTAINER](https://img.shields.io/badge/maintainer-dlpco-blue)

This module provides infrastructure for lambdas to the Dojo Management application.

## Docs

To update these docs, change `./doc.md` and then run `terraform-docs markdown --header-from doc.md --output-file README.md .`.

## Usage

``` hcl
module "lambda" {
  source = "git::git@github.com:DojoManagement/dojo-ft-modules.git//dojo-lambda?ref=dojo-lambda-0.0.1"

  lambda_name     = var.lambda_name
  source_file     = var.source_file #without extension
  handler         = var.handler
  runtime_version = var.runtime_version
  access_s3       = bool
  env             = var.env
  
  routes = [
    {
      method    = "GET"
      path_part = "path1"
    },
    {
      method    = "POST"
      path_part = "path1"
    },
    {
      method    = "POST"
      path_part = "path2"
    }
  ]
}
```
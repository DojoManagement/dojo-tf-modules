# Dojo infrastructure ![MAINTAINER](https://img.shields.io/badge/maintainer-dlpco-blue)

This module provides infrastructure for the core of the Dojo Management application.

## Docs

To update these docs, change `./doc.md` and then run `terraform-docs markdown --header-from doc.md . > README.md`.

## Usage

``` hcl
module "infrastructure" {
  source = "git::git@github.com:DojoManagement/dojo-ft-modules.git//dojo-infra?ref=dojo-infra-0.0.2"

  project_name  = "project_name"
  project_desc  = "project_desc"
  region        = "region"
  env           = "env"
}
```
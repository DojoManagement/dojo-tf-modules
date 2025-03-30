# Dojo Lambda ![MAINTAINER](https://img.shields.io/badge/maintainer-dlpco-blue)

This module provides infrastructure for lambdas to the Dojo Management application.

## Docs

To update these docs, change `./doc.md` and then run `terraform-docs markdown --header-from doc.md . > README.md`.

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
      path_part = "path2"
    }
  ]
}
```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_api_gateway_integration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration) | resource |
| [aws_api_gateway_method.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method) | resource |
| [aws_api_gateway_resource.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_resource) | resource |
| [aws_lambda_alias.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_alias) | resource |
| [aws_lambda_function.lambda_function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.lambda_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [archive_file.zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_api_gateway_rest_api.api_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/api_gateway_rest_api) | data source |
| [aws_iam_role.lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_role) | data source |
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_s3"></a> [access\_s3](#input\_access\_s3) | n/a | `bool` | `false` | no |
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | `"stg"` | no |
| <a name="input_handler"></a> [handler](#input\_handler) | n/a | `string` | n/a | yes |
| <a name="input_lambda_name"></a> [lambda\_name](#input\_lambda\_name) | n/a | `string` | n/a | yes |
| <a name="input_project_desc"></a> [project\_desc](#input\_project\_desc) | n/a | `string` | `"Dojo Management"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | n/a | `string` | `"dojo-management"` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"sa-east-1"` | no |
| <a name="input_routes"></a> [routes](#input\_routes) | n/a | <pre>list(object({<br/>    method    = string<br/>    path_part  = string<br/>  }))</pre> | `[]` | no |
| <a name="input_runtime_version"></a> [runtime\_version](#input\_runtime\_version) | n/a | `string` | `"python3.12"` | no |
| <a name="input_source_file"></a> [source\_file](#input\_source\_file) | the path without extension | `string` | `"../app/lambda_function"` | no |

## Outputs

No outputs.

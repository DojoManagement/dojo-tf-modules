data "aws_api_gateway_rest_api" "api_gateway" {
  name = "${var.project_name}-${var.env}-api"
}

data "terraform_remote_state" "lambda_states" {
  backend = "s3"
  config = {
    bucket = "meu-tfstate"
    key    = "lambda-aulas/terraform.tfstate"
    region = "us-east-1"
  }
}

locals {
  route_checksums = [
    for s in data.terraform_remote_state.lambda_states : s.value.outputs.route_checksum
  ]
}

resource "aws_api_gateway_deployment" "api_gateway_deployment" {
  rest_api_id = data.aws_api_gateway_rest_api.api_gateway.id

  triggers = {
    redeployment = sha1(join(",", local.route_checksums))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "stage" {
  deployment_id = aws_api_gateway_deployment.api_gateway_deployment.id
  rest_api_id   = data.aws_api_gateway_rest_api.api_gateway.id
  stage_name    = var.env
}

resource "aws_api_gateway_method_settings" "example" {
  rest_api_id = data.aws_api_gateway_rest_api.api_gateway.id
  stage_name  = aws_api_gateway_stage.stage.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
  }
}
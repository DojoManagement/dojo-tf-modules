data "aws_api_gateway_rest_api" "api_gateway" {
  name = "${var.project_name}-${var.env}-api"
}

resource "random_id" "redeploy" {
  byte_length = 4
}

resource "aws_api_gateway_deployment" "api_gateway_deployment" {
  rest_api_id = data.aws_api_gateway_rest_api.api_gateway.id
  description = "Deploy-${random_id.redeploy.hex}"

  triggers = {
    redeployment = random_id.redeploy.hex
    token        = var.redeploy_token
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
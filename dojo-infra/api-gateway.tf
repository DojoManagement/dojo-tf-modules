resource "aws_api_gateway_rest_api" "api_gateway" {
  name        = "${var.project_name}-${var.env}-api"
  description = "${var.project_desc} ${var.env} API"
}

resource "aws_api_gateway_account" "account" {
  cloudwatch_role_arn = aws_iam_role.api_gateway_role.arn
}

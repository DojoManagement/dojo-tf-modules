resource "aws_api_gateway_resource" "this" {
  for_each = { for route in var.routes : "${route.path_part}" => route }

  rest_api_id = data.aws_api_gateway_rest_api.api_gateway.id
  parent_id   = data.aws_api_gateway_rest_api.api_gateway.root_resource_id
  path_part   = each.value.path_part
}

resource "aws_api_gateway_method" "this" {
  for_each = { for route in var.routes : "${route.method}#${route.path_part}" => route }

  rest_api_id   = data.aws_api_gateway_rest_api.api_gateway.id
  resource_id   = aws_api_gateway_resource.this["${each.value.method}#${each.value.path_part}"].id
  http_method   = each.value.method
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "this" {
  for_each = { for route in var.routes : "${route.method}#${route.path_part}" => route }

  rest_api_id = data.aws_api_gateway_rest_api.api_gateway.id
  resource_id = aws_api_gateway_resource.this["${each.value.path_part}"].id
  http_method = aws_api_gateway_method.this["${each.value.method}#${each.value.path_part}"].http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = aws_lambda_function.lambda_function.invoke_arn
}
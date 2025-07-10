locals {
  method_map = flatten([
    for route, methods in var.routes : [
      for method in methods : {
        route  = route
        method = method
      }
    ]
  ])
}

resource "aws_api_gateway_resource" "this" {
  for_each = var.routes

  rest_api_id = data.aws_api_gateway_rest_api.api_gateway.id
  parent_id   = data.aws_api_gateway_rest_api.api_gateway.root_resource_id
  path_part   = each.value.path_part
}

resource "aws_api_gateway_method" "this" {
  for_each = { for item in local.method_map : "${item.route}_${item.method}" => item }

  rest_api_id   = data.aws_api_gateway_rest_api.api_gateway.id
  resource_id   = aws_api_gateway_resource.this["${each.value.route}"].id
  http_method   = each.value.method
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "this" {
  for_each = aws_api_gateway_method.this

  rest_api_id = each.value.rest_api_id
  resource_id = each.value.resource_id
  http_method = each.value.http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = aws_lambda_function.lambda_function.invoke_arn
}
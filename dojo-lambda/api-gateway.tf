locals {
  method_map = flatten([
    for route, methods in var.routes : [
      for method in methods : {
        route  = route
        method = method
      }
    ]
  ])
  all_paths = distinct(flatten([
    for path, methods in var.routes : [
      [for i in range(1, length(split("/", path)) + 1) :
        join("/", slice(split("/", path), 0, i))
      ]
    ]
  ]))
}

resource "aws_api_gateway_resource" "this" {
  for_each = { for path in local.all_paths : path => path }

  rest_api_id = data.aws_api_gateway_rest_api.api_gateway.id

  parent_id = (
    length(split("/", each.key)) == 1
    ? data.aws_api_gateway_rest_api.api_gateway.root_resource_id
    : aws_api_gateway_resource.this[
        join("/", slice(split("/", each.key), 0, length(split("/", each.key)) - 1))
      ].id
  )

  path_part = element(reverse(split("/", each.key)), 0)
}

resource "aws_api_gateway_method" "this" {
  for_each = { for item in local.method_map : "${item.route}_${item.method}" => item }

  rest_api_id   = data.aws_api_gateway_rest_api.api_gateway.id
  resource_id   = aws_api_gateway_resource.this["${each.value.route}"].id
  http_method   = each.value.method
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "this" {
  for_each = { for item in local.method_map : "${item.route}_${item.method}" => item }

  rest_api_id = data.aws_api_gateway_rest_api.api_gateway.id
  resource_id = aws_api_gateway_resource.this[item.route].id
  http_method = aws_api_gateway_method.this["${item.route}_${item.method}"].http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = aws_lambda_function.lambda_function.invoke_arn
}
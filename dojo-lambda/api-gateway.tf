locals {
  parent_routes = var.routes.parents
  child_routes  = var.routes.children

  # Expande métodos dos pais
  parent_method_map = flatten([
    for route, methods in local.parent_routes : [
      for method in methods : {
        route_type = "parent"
        route      = route
        method     = method
      }
    ]
  ])

  # Expande métodos dos filhos
  child_method_map = flatten([
    for route, methods in local.child_routes : [
      for method in methods : {
        route_type = "child"
        route      = route
        method     = method
      }
    ]
  ])

  method_map = concat(local.parent_method_map, local.child_method_map)
}

resource "aws_api_gateway_resource" "parent" {
  for_each = local.parent_routes

  rest_api_id = data.aws_api_gateway_rest_api.api_gateway.id
  parent_id   = data.aws_api_gateway_rest_api.api_gateway.root_resource_id
  path_part   = each.key
}

resource "aws_api_gateway_resource" "child" {
  for_each = local.child_routes

  rest_api_id = data.aws_api_gateway_rest_api.api_gateway.id

  parent_id = aws_api_gateway_resource.parent[split("/", each.key)[0]].id
  path_part = element(reverse(split("/", each.key)), 0)
}

#resource "aws_api_gateway_method" "this" {
#  for_each = { for item in local.method_map : "${item.route}_${item.method}" => item }
#
#  rest_api_id   = data.aws_api_gateway_rest_api.api_gateway.id
#  resource_id   = aws_api_gateway_resource.this["${each.value.route}"].id
#  http_method   = each.value.method
#  authorization = "NONE"
#}

resource "aws_api_gateway_method" "this" {
  for_each = { for item in local.method_map : "${item.route}_${item.method}" => item }

  rest_api_id = data.aws_api_gateway_rest_api.api_gateway.id

  resource_id = (
    item.route_type == "parent"
    ? aws_api_gateway_resource.parent["${each.value.route}"].id
    : aws_api_gateway_resource.child["${each.value.route}"].id
  )

  http_method   = item.method
  authorization = "NONE"
}

#resource "aws_api_gateway_integration" "this" {
#  for_each = { for item in local.method_map : "${item.route}_${item.method}" => item }
#
#  rest_api_id = data.aws_api_gateway_rest_api.api_gateway.id
#  resource_id = aws_api_gateway_resource.this["${each.value.route}"].id
#  http_method = aws_api_gateway_method.this["${each.value.route}_${each.value.method}"].http_method
#  integration_http_method = "POST"
#  type = "AWS_PROXY"
#  uri = aws_lambda_function.lambda_function.invoke_arn
#}

resource "aws_api_gateway_integration" "this" {
  for_each = { for item in local.method_map : "${item.route}_${item.method}" => item }

  rest_api_id = data.aws_api_gateway_rest_api.api_gateway.id

  resource_id = (
    item.route_type == "parent"
    ? aws_api_gateway_resource.parent["${each.value.route}"].id
    : aws_api_gateway_resource.child["${each.value.route}"].id
  )

  http_method             = aws_api_gateway_method.this["${each.value.route}_${each.value.method}"].http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_function.invoke_arn
}
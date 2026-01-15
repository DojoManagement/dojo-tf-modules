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

resource "aws_api_gateway_method" "this" {
  for_each = { for item in local.method_map : "${item.route}_${item.method}" => item }

  rest_api_id = data.aws_api_gateway_rest_api.api_gateway.id

  resource_id = (
    each.value.route_type == "parent"
    ? aws_api_gateway_resource.parent["${each.value.route}"].id
    : aws_api_gateway_resource.child["${each.value.route}"].id
  )

  http_method   = each.value.method
  authorization = "NONE"
}

#resource "aws_api_gateway_integration" "this" {
#  for_each = { for item in local.method_map : "${item.route}_${item.method}" => item }
#
#  rest_api_id = data.aws_api_gateway_rest_api.api_gateway.id
#
#  resource_id = (
#    each.value.route_type == "parent"
#    ? aws_api_gateway_resource.parent["${each.value.route}"].id
#    : aws_api_gateway_resource.child["${each.value.route}"].id
#  )
#
#  http_method             = aws_api_gateway_method.this["${each.value.route}_${each.value.method}"].http_method
#  integration_http_method = "POST"
#  type                    = "AWS_PROXY"
#  uri                     = aws_lambda_function.lambda_function.invoke_arn
#}

# Integration - Diferente para OPTIONS (MOCK) e outros métodos (AWS_PROXY)
resource "aws_api_gateway_integration" "this" {
  for_each = { for item in local.method_map : "${item.route}_${item.method}" => item }

  rest_api_id = data.aws_api_gateway_rest_api.api_gateway.id
  resource_id = (
    each.value.route_type == "parent"
    ? aws_api_gateway_resource.parent["${each.value.route}"].id
    : aws_api_gateway_resource.child["${each.value.route}"].id
  )
  http_method = aws_api_gateway_method.this["${each.value.route}_${each.value.method}"].http_method
  
  # Se for OPTIONS, usa MOCK; caso contrário, AWS_PROXY
  type                    = each.value.method == "OPTIONS" ? "MOCK" : "AWS_PROXY"
  integration_http_method = each.value.method == "OPTIONS" ? null : "POST"
  uri                     = each.value.method == "OPTIONS" ? null : aws_lambda_function.lambda_function.invoke_arn
  
  # Request template para MOCK (retorna 200)
  request_templates = each.value.method == "OPTIONS" ? {
    "application/json" = jsonencode({ statusCode = 200 })
  } : null
}

# Method Response - Apenas para OPTIONS
resource "aws_api_gateway_method_response" "options" {
  for_each = { for item in local.method_map : "${item.route}_${item.method}" => item if item.method == "OPTIONS" }

  rest_api_id = data.aws_api_gateway_rest_api.api_gateway.id
  resource_id = (
    each.value.route_type == "parent"
    ? aws_api_gateway_resource.parent["${each.value.route}"].id
    : aws_api_gateway_resource.child["${each.value.route}"].id
  )
  http_method = aws_api_gateway_method.this["${each.value.route}_${each.value.method}"].http_method
  status_code = "200"
  
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
  
  response_models = {
    "application/json" = "Empty"
  }
}

# Integration Response - Apenas para OPTIONS
resource "aws_api_gateway_integration_response" "options" {
  for_each = { for item in local.method_map : "${item.route}_${item.method}" => item if item.method == "OPTIONS" }

  rest_api_id = data.aws_api_gateway_rest_api.api_gateway.id
  resource_id = (
    each.value.route_type == "parent"
    ? aws_api_gateway_resource.parent["${each.value.route}"].id
    : aws_api_gateway_resource.child["${each.value.route}"].id
  )
  http_method = aws_api_gateway_method.this["${each.value.route}_${each.value.method}"].http_method
  status_code = aws_api_gateway_method_response.options["${each.value.route}_${each.value.method}"].status_code
  
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
  
  depends_on = [
    aws_api_gateway_integration.this
  ]
}
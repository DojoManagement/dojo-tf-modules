resource "aws_lambda_function" "lambda_function" {
  filename         = "lambda_package.zip"
#  filename         = data.archive_file.zip.output_path
#  source_code_hash = data.archive_file.zip.output_base64sha256

  function_name = "${var.lambda_name}-${var.env}"
  role          = data.aws_iam_role.lambda_role.arn
  handler       = var.handler
  runtime       = var.runtime_version
  timeout       = 10

  dynamic "environment" { 
    for_each = var.access_s3 ? [1] : []
      
    content {
      variables = {
        S3_BUCKET = data.aws_s3_bucket.this.id
      }
    }
  }
}

resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${data.aws_api_gateway_rest_api.api_gateway.execution_arn}/*/*"
}

resource "aws_lambda_alias" "this" {
  name             = var.env
  description      = "Alias to ${var.env}"
  function_name    = aws_lambda_function.lambda_function.arn
  function_version = "$LATEST"
}
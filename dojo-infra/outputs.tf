output "s3_bucket_name" {
  description = "Nome do bucket S3"
  value       = aws_s3_bucket.this
}

output "api_gateway_url" {
  description = "URL da API Gateway"
  value       = "https://${aws_api_gateway_rest_api.api_gateway.id}.execute-api.us-east-1.amazonaws.com/prod"
}

output "api_gateway" {
  description = "API Gateway"
  value       = aws_api_gateway_rest_api.api_gateway.id
}

# ========================================
# OUTPUT - FRONTEND
# ========================================

output "bucket_name_frontend" {
  description = "Nome do bucket S3"
  value       = aws_s3_bucket.frontend.id
}

output "bucket_arn_frontend" {
  description = "ARN do bucket S3"
  value       = aws_s3_bucket.frontend.arn
}

output "website_endpoint_frontend" {
  description = "Endpoint do website S3"
  value       = aws_s3_bucket_website_configuration.frontend.website_endpoint
}

output "website_url_frontend" {
  description = "URL completa do website"
  value       = "http://${aws_s3_bucket_website_configuration.frontend.website_endpoint}"
}
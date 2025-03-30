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
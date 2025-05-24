data "aws_api_gateway_rest_api" "api_gateway" {
  name = "${var.project_name}-${var.env}-api"
}

data "archive_file" "zip" {
  type        = "zip"
  source_dir = "${var.source_dir}.py"
  output_path = "${var.source_dir}/athletemgmt.zip"
}

data "aws_iam_role" "lambda_role" {
  name = "lambda-${var.project_name}-${var.env}-role"
}

data "aws_s3_bucket" "this" {
  bucket = "${var.project_name}-${var.env}"
}
data "aws_s3_bucket" "selected" {
  bucket = "${var.project_name}-${var.env}"
}

resource "aws_s3_bucket_object" "lambda_zip" {
  bucket = data.aws_s3_bucket.selected.id
  key    = "lambda_build/${var.lambda_name}/lambda_package.zip"
  source = "../lambda_build/lambda_package.zip"
  etag   = filemd5("../lambda_build/lambda_package.zip")
}
resource "aws_iam_role" "lambda_role" {
  name        = "lambda-${var.project_name}-${var.env}-role"
  description = "Lambda ${var.project_desc} ${var.env} Policy"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda-${var.project_name}-${var.env}-policy"
  description = "Lambda ${var.project_desc} ${var.env} Policy"

  policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "ec2:Describe*",
          ]
          Effect   = "Allow"
          Resource = "*"
        },
        {
          Action = [
            "s3:ListBucket",
            "s3:PutObject",
            "s3:GetObject"
          ]
          Effect   = "Allow"
          Resource = [
            "${aws_s3_bucket.this.arn}",
            "${aws_s3_bucket.this.arn}/*"
          ]
        },
        {
          Action = [
            "lambda:InvokeFunction"
          ]
          Effect   = "Allow"
          Resource = "*"
        },
        {
          Action = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:DescribeLogGroups",
            "logs:DescribeLogStreams",
            "logs:PutLogEvents",
            "logs:GetLogEvents",
            "logs:FilterLogEvents"
          ]
          Effect   = "Allow"
          Resource = "*"
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "role-policy-attachment" {
  policy_arn = aws_iam_policy.lambda_policy.arn
  role       = aws_iam_role.lambda_role.id
}
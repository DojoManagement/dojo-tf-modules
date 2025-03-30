resource "aws_iam_role" "api_gateway_role" {
  name        = "api-gateway-${var.project_name}-${var.env}-role"
  description = "Api Gateway ${var.project_desc} ${var.env} Policy"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
      },
    ]
  })
}


resource "aws_iam_policy" "api_gateway_policy" {
  name        = "api-gateway-${var.project_name}-${var.env}-policy"
  description = "Api Gateway ${var.project_desc} ${var.env} Policy"

  policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
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

resource "aws_iam_role_policy_attachment" "api_gateway" {
  policy_arn = aws_iam_policy.api_gateway_policy.arn
  role       = aws_iam_role.api_gateway_role.id
}
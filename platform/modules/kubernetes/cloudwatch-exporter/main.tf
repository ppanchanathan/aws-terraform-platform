resource "aws_iam_policy" "this" {
  name = "${var.role_name}-cloudwatch"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:GetMetricData",
          "cloudwatch:ListMetrics",
          "tag:GetResources"
        ]
        Resource = "*"
      }
    ]
  })

  tags = var.tags
}

module "irsa" {
  source = "../irsa"

  role_name            = var.role_name
  namespace            = var.namespace
  service_account_name = var.service_account_name
  oidc_provider_arn    = var.oidc_provider_arn
  oidc_issuer_url      = var.oidc_issuer_url

  policy_arns = {
    cloudwatch = aws_iam_policy.this.arn
  }

  tags = var.tags
}
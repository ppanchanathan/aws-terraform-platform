resource "aws_iam_policy" "this" {
  name = "${var.role_name}-secrets"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = var.secret_arns
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
    secretsmanager = aws_iam_policy.this.arn
  }

  tags = var.tags
}
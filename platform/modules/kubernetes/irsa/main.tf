locals {

  issuer_without_https = replace(
    var.oidc_issuer_url,
    "https://",
    ""
  )
}

resource "aws_iam_role" "this" {

  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Federated = var.oidc_provider_arn
        }

        Action = "sts:AssumeRoleWithWebIdentity"

        Condition = {
          StringEquals = {
            "${local.issuer_without_https}:sub" = "system:serviceaccount:${var.namespace}:${var.service_account_name}"
          }
        }
      }
    ]
  })

  tags = var.tags
}

/*
resource "aws_iam_role_policy_attachment" "this" {

  for_each = toset(var.policy_arns)

  role       = aws_iam_role.this.name
  policy_arn = each.value
}
*/

resource "aws_iam_role_policy_attachment" "this" {

  for_each = var.policy_arns

  role       = aws_iam_role.this.name
  policy_arn = each.value
}



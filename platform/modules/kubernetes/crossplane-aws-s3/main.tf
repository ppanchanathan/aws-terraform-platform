resource "aws_iam_policy" "this" {
  name = "${var.role_name}-s3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowS3BucketManagement"
        Effect = "Allow"
        Action = [
          "s3:CreateBucket",
          "s3:DeleteBucket",
          "s3:GetBucketAcl",
          "s3:GetBucketPolicy",
          "s3:PutBucketPolicy",
          "s3:DeleteBucketPolicy",
          "s3:GetBucketTagging",
          "s3:PutBucketTagging",
          "s3:GetBucketVersioning",
          "s3:PutBucketVersioning",
          "s3:GetEncryptionConfiguration",
          "s3:PutEncryptionConfiguration",
          "s3:ListBucket",
          "s3:ListAllMyBuckets",
          "s3:GetBucketLocation",
          "s3:GetAccelerateConfiguration",
          "s3:PutAccelerateConfiguration",
          "s3:GetBucketCORS",
          "s3:PutBucketCORS",
          "s3:GetBucketLogging",
          "s3:PutBucketLogging",
          "s3:GetBucketNotification",
          "s3:PutBucketNotification",
          "s3:GetBucketObjectLockConfiguration",
          "s3:GetBucketOwnershipControls",
          "s3:PutBucketOwnershipControls",
          "s3:GetBucketPublicAccessBlock",
          "s3:PutBucketPublicAccessBlock",
          "s3:GetBucketRequestPayment",
          "s3:PutBucketRequestPayment",
          "s3:GetBucketWebsite",
          "s3:PutBucketWebsite",
          "s3:GetReplicationConfiguration",
          "s3:PutReplicationConfiguration",
          "s3:GetLifecycleConfiguration",
          "s3:PutLifecycleConfiguration",
          "s3:GetBucketPolicyStatus"
        ]
        Resource = "*"
      }
    ]
  })

  tags = merge(
    {
      Name = "${var.role_name}-s3"
    },
    var.tags
  )
}
module "irsa" {
  source = "../irsa"

  role_name            = var.role_name
  namespace            = var.namespace
  service_account_name = var.service_account_name
  oidc_provider_arn    = var.oidc_provider_arn
  oidc_issuer_url      = var.oidc_issuer_url

  policy_arns = {
    s3 = aws_iam_policy.this.arn
  }

  tags = var.tags
}

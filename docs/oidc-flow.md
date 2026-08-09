# OIDC Flow

GitHub Actions requests an OIDC token.

AWS validates the token using the IAM OIDC provider.

AWS STS allows the workflow to assume the GitHub Terraform role.

# Bootstrap

This directory is Phase 0.

Run this locally first using AWS CLI credentials.

Do not destroy these resources casually.

Critical resources:
- GitHub OIDC provider
- GitHub Actions IAM role
- Terraform state bucket
- DynamoDB lock table


# Bootstrap Infrastructure

This stack creates:

- GitHub OIDC Provider
- GitHub Actions IAM Role
- Terraform S3 Backend
- Terraform DynamoDB Locking

Run locally.

Do not destroy casually.

These resources are required for GitHub Actions authentication.

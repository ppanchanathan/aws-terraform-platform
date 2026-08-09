# Bootstrap Runbook

If GitHub Actions fails with:

Could not assume role with OIDC

Check AWS IAM Identity Providers.

Required provider:

token.actions.githubusercontent.com

Recovery:

cd bootstrap
terraform init
terraform plan
terraform apply

Never casually destroy bootstrap resources.

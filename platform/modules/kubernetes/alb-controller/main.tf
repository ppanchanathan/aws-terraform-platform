resource "aws_iam_policy" "this" {
  name   = "AWSLoadBalancerControllerIAMPolicy"
  policy = file("${path.module}/policy.json")
}

module "irsa" {

  source = "../irsa"

  role_name            = var.role_name
  namespace            = var.namespace
  service_account_name = var.service_account_name
  oidc_provider_arn    = var.oidc_provider_arn
  oidc_issuer_url      = var.oidc_issuer_url
  /*  policy_arns = [
    aws_iam_policy.this.arn
  ]
*/
  policy_arns = {
    alb = aws_iam_policy.this.arn
  }
  tags = var.tags
}
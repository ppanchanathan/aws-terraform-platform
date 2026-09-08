resource "aws_sqs_queue" "interruption" {
  name                      = "${var.cluster_name}-karpenter-interruption"
  message_retention_seconds = 300

  tags = merge(
    {
      Name = "${var.cluster_name}-karpenter-interruption"
    },
    var.tags
  )
}

resource "aws_iam_policy" "controller" {
  name = "${var.role_name}-controller"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "AllowScopedEC2InstanceActions"
        Effect   = "Allow"
        Resource = "*"
        Action = [
          "ec2:RunInstances",
          "ec2:CreateFleet",
          "ec2:CreateLaunchTemplate",
          "ec2:CreateTags",
          "ec2:TerminateInstances",
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeInstanceTypeOfferings",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeLaunchTemplates",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSpotPriceHistory",
          "ec2:DescribeImages",
          "pricing:GetProducts",
          "ssm:GetParameter",
          "eks:DescribeCluster"
        ]
      },
      {
        Sid      = "AllowPassingInstanceRole"
        Effect   = "Allow"
        Action   = "iam:PassRole"
        Resource = var.node_role_arn
      },
      {
        Sid      = "AllowInterruptionQueueActions"
        Effect   = "Allow"
        Action   = ["sqs:DeleteMessage", "sqs:GetQueueUrl", "sqs:ReceiveMessage"]
        Resource = aws_sqs_queue.interruption.arn
      }
    ]
  })

  tags = merge(
    {
      Name = "${var.role_name}-controller"
    },
    var.tags
  )
}

module "irsa" {
  source = "../irsa"

  role_name            = var.role_name
  namespace            = "kube-system"
  service_account_name = "karpenter"
  oidc_provider_arn    = var.oidc_provider_arn
  oidc_issuer_url      = var.oidc_issuer_url

  policy_arns = {
    controller = aws_iam_policy.controller.arn
  }

  tags = var.tags
}

resource "aws_iam_instance_profile" "karpenter_node" {
  name = "${var.role_name}-node-profile"
  role = var.node_role_name

  tags = merge(
    {
      Name = "${var.role_name}-node-profile"
    },
    var.tags
  )
}
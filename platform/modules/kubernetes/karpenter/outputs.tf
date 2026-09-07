output "controller_role_arn" {
  value = module.irsa.role_arn
}
output "node_instance_profile_name" {
  value = aws_iam_instance_profile.karpenter_node.name
}
output "interruption_queue_name" {
  value = aws_sqs_queue.interruption.name
}
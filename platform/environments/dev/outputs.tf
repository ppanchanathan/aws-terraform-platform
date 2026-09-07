output "cloudwatch_exporter_role_arn" {
  value = module.cloudwatch_exporter.role_arn
}
output "karpenter_controller_role_arn" {
  value = module.karpenter.controller_role_arn
}
output "karpenter_node_instance_profile_name" {
  value = module.karpenter.node_instance_profile_name
}
output "karpenter_interruption_queue_name" {
  value = module.karpenter.interruption_queue_name
}
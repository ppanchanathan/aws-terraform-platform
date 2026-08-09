output "github_actions_role_name" {
  value = aws_iam_role.github_actions.name
}

output "github_role_arn" {
  value = aws_iam_role.github_actions.arn
}

output "state_bucket" {
  value = aws_s3_bucket.terraform_state.bucket
}

output "lock_table" {
  value = aws_dynamodb_table.terraform_locks.name
}

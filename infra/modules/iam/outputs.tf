output "lambda_role_arns" {
  description = "Map of lambda role ARNs"
  value = {
    for k, r in aws_iam_role.lambda :
    k => r.arn
  }
}

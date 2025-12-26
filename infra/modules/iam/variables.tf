variable "project_name" {
  type        = string
  description = "Project name (used for naming IAM resources)"
}

variable "environment" {
  type        = string
  description = "Environment name (dev, prod)"
}

variable "lambda_roles" {
  description = "Map of lambda roles and their permissions"
  type = map(object({
    dynamodb_arns = list(string)
    sqs_arns      = list(string)
    sns_arns      = list(string)
  }))
}

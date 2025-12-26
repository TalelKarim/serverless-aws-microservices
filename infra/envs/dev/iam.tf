module "iam" {
  source = "../../modules/iam"

  project_name = local.project
  environment  = local.env

  lambda_roles = {
    order_creation = {
      dynamodb_arns = ["arn:aws:dynamodb:${var.region}:${var.account_id}:table/orders"]
      sqs_arns      = ["arn:aws:sqs:${var.region}:${var.account_id}:order-queue"]
      sns_arns      = []
    }

    payment_validation = {
      dynamodb_arns = ["arn:aws:dynamodb:${var.region}:${var.account_id}:table/orders"]
      sqs_arns      = []
      sns_arns      = []
    }

    fulfillment_processing = {
      dynamodb_arns = ["arn:aws:dynamodb:${var.region}:${var.account_id}:table/orders"]
      sqs_arns      = ["arn:aws:sqs:${var.region}:${var.account_id}:fulfillment-queue"]
      sns_arns      = ["arn:aws:sns:${var.region}:${var.account_id}:order-events"]
    }
  }
}

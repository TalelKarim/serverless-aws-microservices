data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}


resource "aws_iam_role" "lambda" {
  for_each = var.lambda_roles

  name = "${var.project_name}-${var.environment}-${each.key}-role"

  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}


data "aws_iam_policy_document" "dynamodb" {
  for_each = var.lambda_roles

  statement {
    effect = "Allow"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
      "dynamodb:Query"
    ]
    resources = each.value.dynamodb_arns
  }
}


data "aws_iam_policy_document" "sqs" {
  for_each = var.lambda_roles

  statement {
    effect = "Allow"
    actions = [
      "sqs:SendMessage",
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes"
    ]
    resources = each.value.sqs_arns
  }
}


data "aws_iam_policy_document" "sns" {
  for_each = var.lambda_roles

  statement {
    effect = "Allow"
    actions = ["sns:Publish"]
    resources = each.value.sns_arns
  }
}




data "aws_iam_policy_document" "lambda_combined" {
  for_each = var.lambda_roles

  source_policy_documents = compact([
    length(each.value.dynamodb_arns) > 0 ? data.aws_iam_policy_document.dynamodb[each.key].json : null,
    length(each.value.sqs_arns) > 0 ? data.aws_iam_policy_document.sqs[each.key].json : null,
    length(each.value.sns_arns) > 0 ? data.aws_iam_policy_document.sns[each.key].json : null
  ])
}


resource "aws_iam_role_policy" "lambda" {
  for_each = var.lambda_roles

  role   = aws_iam_role.lambda[each.key].id
  policy = data.aws_iam_policy_document.lambda_combined[each.key].json
}


resource "aws_iam_role_policy_attachment" "cloudwatch_logs" {
  for_each = aws_iam_role.lambda

  role       = each.value.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "aws_iam_policy_document" "lambda_ai_assume_role" {
    statement {
        actions = ["sts:AssumeRole"]
        principals {
            type = "Service"
            identifiers = ["lambda.amazonaws.com"]
        }
    }
}

data "aws_iam_policy_document" "lambda_ai_policy_document" {

    # Allows Lambda to perform proper logging
    statement {
        actions = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents",
            "ec2:CreateNetworkInterface",
            "ec2:DescribeNetworkInterfaces",
            "ec2:DeleteNetworkInterface"
        ]
        resources = ["*"]
    }
}

resource "aws_iam_role" "lambda_ai_iam_role" {
  name = "${local.prefix}-lambda-ai-iam-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_ai_assume_role.json
}

resource "aws_iam_policy" "lambda_ai_iam_policy" {
    name = "${local.prefix}-lambda-ai-policy"
    policy = data.aws_iam_policy_document.lambda_ai_policy_document.json
}

resource "aws_iam_role_policy_attachment" "lambda_ai_policy_attachment" {
    role = aws_iam_role.lambda_ai_iam_role.name
    policy_arn = aws_iam_policy.lambda_ai_iam_policy.arn
}
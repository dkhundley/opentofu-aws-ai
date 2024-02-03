data "archive_file" "lambda_ai_zip" {
    type = "zip"
    source_dir = "../lambdas/lambda_ai"
    output_path = "../lambdas/lambda_ai.zip"
}


resource "aws_lambda_function" "lambda_ai" {
    function_name = "${local.prefix}-lambda"
    role = aws_iam_role.lambda_ai_iam_role.arn
    filename = data.archive_file.lambda_ai_zip.output_path
    source_code_hash = data.archive_file.lambda_ai_zip.output_base64sha256
    runtime = "python3.8"
    handler = "lambda_ai.lambda_handler"
    layers = [aws_lambda_layer_version.lambda_langchain_layer.arn, aws_lambda_layer_version.lambda_openai_layer.arn]
    timeout = 60
}
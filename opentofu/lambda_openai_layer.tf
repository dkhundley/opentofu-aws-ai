# Creating the ZIP file to be uploaded to Lambda
data "archive_file" "lambda_openai_layer_zip" {
    type = "zip"
    source_dir = "${path.root}/../lambdas/openai_layer"
    output_path = "${path.root}/../lambdas/openai_layer.zip"
}

resource "aws_lambda_layer_version" "lambda_openai_layer" {
    layer_name = "${local.prefix}-oai-layer"
    filename = data.archive_file.lambda_openai_layer_zip.output_path
    source_code_hash = data.archive_file.lambda_openai_layer_zip.output_base64sha256
    compatible_runtimes = ["python3.8"]
}
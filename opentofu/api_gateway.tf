data "aws_iam_policy_document" "api_gateway_policy_doc" {

    # Defining the ALLOW rules
    statement {
        effect = "Allow"
        actions = ["execute-api:Invoke"]
        resources = ["execute-api:/*"]
        principals {
            type = "*"
            identifiers = ["*"]
        }
    }
}



# Creating the API itself within the API Gateway
resource "aws_api_gateway_rest_api" "api" {
    name = "${local.prefix}-api"
    policy = data.aws_iam_policy_document.api_gateway_policy_doc.json
}






# Creatingt the API Gateway deployment
resource "aws_api_gateway_deployment" "api_deployment" {
    rest_api_id = aws_api_gateway_rest_api.api.id
    stage_description = "Deployed at ${timestamp()}"

    # Ensuring the resources listed below are created before the API deployment is created
    depends_on = [
        aws_api_gateway_method.post_method,
        aws_api_gateway_integration.inference_integration
    ]

    lifecycle {
        create_before_destroy = true
    }
}


resource "aws_api_gateway_stage" "api_stage" {
    stage_name = "TEST"
    rest_api_id = aws_api_gateway_rest_api.api.id
    deployment_id = aws_api_gateway_deployment.api_deployment.id
}

resource "aws_api_gateway_resource" "inference_resource" {
    rest_api_id = aws_api_gateway_rest_api.api.id
    parent_id = aws_api_gateway_rest_api.api.root_resource_id
    path_part = "inference"
}

resource "aws_api_gateway_method" "post_method" {
    rest_api_id = aws_api_gateway_rest_api.api.id
    resource_id = aws_api_gateway_resource.inference_resource.id
    http_method = "POST"
    authorization = "NONE"
}

resource "aws_api_gateway_integration" "inference_integration" {
    rest_api_id = aws_api_gateway_rest_api.api.id
    resource_id = aws_api_gateway_resource.inference_resource.id
    http_method = aws_api_gateway_method.post_method.http_method

    integration_http_method = "POST"
    type = "AWS_PROXY"
    uri = aws_lambda_function.lambda_ai.invoke_arn
}

resource "aws_lambda_permission" "api_gateway_lambda_ai_permission" {
    statement_id = "AllowExecutionFromAPIGateway"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.lambda_ai.function_name
    principal = "apigateway.amazonaws.com"
}
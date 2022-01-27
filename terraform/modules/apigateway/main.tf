### APIGateway module

resource "aws_apigatewayv2_api" "lambda" {
  name          = var.api_name
  protocol_type = "HTTP"
}

resource "aws_cloudwatch_log_group" "gateway_log_group" {
  name              = "/aws/api-gateway/lambda"
  retention_in_days = 3
}

resource "aws_apigatewayv2_stage" "lambda" {
  api_id = aws_apigatewayv2_api.lambda.id

  name        = "serverless_lambda_stage"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.gateway_log_group.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}


### Population
resource "aws_apigatewayv2_integration" "population" {
  api_id = aws_apigatewayv2_api.lambda.id

  integration_uri    = var.population_lambda_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "population" {
  api_id = aws_apigatewayv2_api.lambda.id

  route_key = "POST /populate"
  target    = "integrations/${aws_apigatewayv2_integration.population.id}"
}

resource "aws_lambda_permission" "population" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.population_function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}

### Transactions
resource "aws_apigatewayv2_integration" "transactions" {
  api_id = aws_apigatewayv2_api.lambda.id

  integration_uri    = var.transactions_lambda_arn
  integration_type   = "AWS_PROXY"
  integration_method = "ANY"
}

resource "aws_apigatewayv2_route" "transactions" {
  api_id = aws_apigatewayv2_api.lambda.id

  route_key = "GET /transactions"
  target    = "integrations/${aws_apigatewayv2_integration.transactions.id}"
}

resource "aws_apigatewayv2_route" "transactions_id" {
  api_id = aws_apigatewayv2_api.lambda.id

  route_key = "GET /transactions/{transaction_id}"
  target    = "integrations/${aws_apigatewayv2_integration.transactions.id}"
}

resource "aws_lambda_permission" "transactions" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.transactions_function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}

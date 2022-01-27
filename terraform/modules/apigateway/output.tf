output "base_url" {
  description = "API Gateway stage URL"
  value       = aws_apigatewayv2_stage.lambda.invoke_url
}

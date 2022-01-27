### APIGateway variables
variable "api_name" {
  type        = string
  description = "name of the api"
}

variable "population_lambda_arn" {
  type        = string
  description = "ARN of the population Lambda function"
}

variable "population_function_name" {
  type        = string
  description = "Name of the population Lambda function"
}

variable "transactions_lambda_arn" {
  type        = string
  description = "ARN of the transactions Lambda function"
}

variable "transactions_function_name" {
  type        = string
  description = "Name of the transactions Lambda function"
}

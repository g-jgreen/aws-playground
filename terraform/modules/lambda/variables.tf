### Lambda variables
variable "function_name" {
  type        = string
  description = "name of the lambda function"
}

variable "s3_bucket" {
  type        = string
  description = "bucket where the lambda function's code is stored"
  default     = "infra-challenge-lambda"
}

variable "zip_name" {
  type        = string
  description = "name of the lambda function zip on s3"
}

variable "handler" {
  type        = string
  description = "function handler"
  default     = "lambda_handler"
}

variable "runtime" {
  type        = string
  description = "lambda runtime"
  default     = "python3.8"
}

variable "timeout" {
  type        = number
  description = "timeout in second for the lambda function"
  default     = 3
}

variable "dynamodb_table" {
  type = string
  description = "Name of the DynamoDB table"
}
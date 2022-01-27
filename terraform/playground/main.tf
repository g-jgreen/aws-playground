## Main tenant build
terraform {
  required_version = ">= 0.13"


  backend "s3" {
    bucket = "primer-challenge-terraform-state"
    key    = "primer-challenge/playground"
    region = "eu-west-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.73.0"
    }
  }
}

### AWS as default provider
provider "aws" {
  region  = var.aws_region
}

### Create the dynamodb table
module "dynamodb" {
  source        = "../modules/dynamodb"
  table_name    = "${var.environment}-transaction-challenge"
  hash_key      = "transaction_id"
  environment   = var.environment
}

### Provision the bucket to store the lambda source code
module "lambda_source_bucket" {
  source      = "../modules/s3"
  name        = "primer-challenge-functions-${var.environment}"
  environment = var.environment
}

### Provision the Lambda source code to the lambda source bucket
module "provision_lambda_source" {
  source      = "../modules/s3_object"
  for_each    = fileset("../../functions", "*")
  file        = each.key
  file_source = "../../functions"
  bucket_name = module.lambda_source_bucket.name
}

### Provision the Lambda Layer
module "provision_lambda_layers" {
  source      = "../modules/s3_object"
  for_each    = fileset("../../layers", "*")
  file        = each.key
  file_source = "../../layers"
  bucket_name = module.lambda_source_bucket.name
}

### Provision population Lambda function
module "populate_lambda" {
  source         = "../modules/lambda"
  function_name  = "populate-function-${var.environment}"
  zip_name       = "populate.zip"
  handler        = "populate.lambda_handler"
  s3_bucket      = module.lambda_source_bucket.name
  dynamodb_table = module.dynamodb.table_name

  depends_on = [
    module.dynamodb,
    module.provision_lambda_layers
  ]
}

### Build the transaction Lambda function
module "transaction_lambda" {
  source         = "../modules/lambda"
  function_name  = "transactions-function-${var.environment}"
  zip_name       = "transactions.zip"
  handler        = "transactions.app"
  s3_bucket      = module.lambda_source_bucket.name
  dynamodb_table = module.dynamodb.table_name

  depends_on = [
    module.dynamodb,
    module.provision_lambda_layers
  ]
}

### Add the API gateway
module "apigateway" {
  source        = "../modules/apigateway"
  api_name      = "${var.environment}-transaction-api"

  population_lambda_arn      = module.populate_lambda.lambda_arn
  population_function_name   = "populate-function-${var.environment}"
  transactions_lambda_arn    = module.transaction_lambda.lambda_arn
  transactions_function_name = "transactions-function-${var.environment}"
}

output "base_url" {
  description = "API Gateway stage URL"
  value = module.apigateway.base_url
}

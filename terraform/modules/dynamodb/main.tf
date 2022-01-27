### DynamoDB module

resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = var.table_name
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = var.hash_key
  ## Use the 'date' key for sorting
  range_key      = "date"

  attribute {
    name = var.hash_key
    type = "S"
  }

  attribute {
    name = "date"
    type = "S"
  }

  tags = {
    Name        = var.table_name
    Environment = var.environment
  }
}
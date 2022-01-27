### DynamoDB variables
variable "table_name" {
  type        = string
  description = "Table name"
}

variable "hash_key" {
  type        = string
  description = "Hash (partition) key"
}

variable "environment" {
  type = string
}

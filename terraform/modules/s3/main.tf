## s3 Bucket module

resource "aws_s3_bucket" "bucket" {
  bucket = var.name
  acl    = var.acl

  tags = {
    Name        = var.name
    Environment = var.environment
  }
}

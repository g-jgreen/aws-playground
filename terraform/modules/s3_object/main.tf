## Lambda function as an object

resource "aws_s3_bucket_object" "object" {
  bucket                 = var.bucket_name
  key                    = var.file
  source                 = "${var.file_source}/${var.file}"
  server_side_encryption = "aws:kms"
  etag = filemd5("${var.file_source}/${var.file}")
}

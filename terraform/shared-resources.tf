
# A generic, global key-value store for reuse across applications.

resource "aws_dynamodb_table" "global-store" {
  provider = aws.secondary
  hash_key = "k"
  name     = "${var.app_name}-global-store-${terraform.workspace}"
  attribute {
    name = "k"
    type = "S"
  }
  ttl {
    attribute_name = "ExpiresAt"
    enabled = true
  }
  billing_mode = "PAY_PER_REQUEST"
}

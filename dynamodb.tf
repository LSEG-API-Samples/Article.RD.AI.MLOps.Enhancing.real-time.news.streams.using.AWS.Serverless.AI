resource "aws_dynamodb_table" "nlp_news_headlines_table" {
  name             = "nlp_news_headlines_table"
  billing_mode     = "PROVISIONED"
  read_capacity    = 20
  write_capacity   = 20
  hash_key         = "id"
  stream_enabled   = true
  stream_view_type = "NEW_IMAGE"

  attribute {
    name = "id"
    type = "S"
  }
}

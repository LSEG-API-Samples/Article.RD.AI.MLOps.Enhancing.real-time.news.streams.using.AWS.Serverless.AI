resource "aws_kinesis_stream" "nlp_kinesis_stream" {
  name             = "my-nlp-kinesis-en"
  shard_count      = 1
  retention_period = 24

  shard_level_metrics = ["IncomingBytes", "OutgoingBytes"]

  tags = { Environment = "UAT" }
}

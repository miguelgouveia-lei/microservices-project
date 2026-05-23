resource "aws_sqs_queue" "dlq" {
  name = "${var.name_prefix}-product-events-dlq"
}

resource "aws_sqs_queue" "main" {
  name                       = "${var.name_prefix}-product-events"
  visibility_timeout_seconds = 60
  message_retention_seconds  = 345600
  receive_wait_time_seconds  = 20

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq.arn
    maxReceiveCount     = 5
  })
}

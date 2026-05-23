resource "aws_sqs_queue" "product_events_dlq" {
  name = "terraform-product-events-dlq"
}

resource "aws_sqs_queue" "product_events" {
  name = "terraform-product-events"

  visibility_timeout_seconds = 60

  message_retention_seconds = 345600

  receive_wait_time_seconds = 20

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.product_events_dlq.arn
    maxReceiveCount     = 5
  })
}

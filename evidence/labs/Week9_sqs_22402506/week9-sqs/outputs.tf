output "product_events_queue_url" {
  value = aws_sqs_queue.product_events.id
}

output "product_events_queue_arn" {
  value = aws_sqs_queue.product_events.arn
}

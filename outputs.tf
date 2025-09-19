output "listener_arn" {
  description = "ARN do listener HTTPS"
  value       = aws_lb_listener.encrypted.arn
}

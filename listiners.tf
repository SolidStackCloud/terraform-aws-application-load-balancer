resource "aws_lb_listener" "encrypted" {
  load_balancer_arn = aws_lb.main.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type = var.alb_fixed_response.type

    fixed_response {
      content_type = var.alb_fixed_response.content_type
      message_body = var.alb_fixed_response.message_body
      status_code  = var.alb_fixed_response.status_code
    }
  }
}

resource "aws_lb_listener" "unencrypted" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
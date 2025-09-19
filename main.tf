resource "aws_lb" "main" {
  name               = "${var.project_name}-alb"
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = [aws_security_group.main.id]
  subnets            = var.public_subnets

  enable_deletion_protection = var.enable_deletion_protection

  access_logs {
    bucket  = var.access_logs.access_logs_bucket
    prefix  = var.access_logs.access_logs_prefix
    enabled = var.access_logs.enable_access_logs
  }

  tags = {
    Name = "${var.project_name}-alb"
  }
}


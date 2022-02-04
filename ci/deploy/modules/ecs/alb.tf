resource "aws_lb_target_group" "backend" {
  # Underscore is not allowed in target group name
  name        = "devops-demoapp-${var.environment}-backend"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/health"
    unhealthy_threshold = "2"
  }

  tags = {
    Name      = "${var.project}-${var.environment}-backend-target-group"
    ManagedBy = "${var.iac_tool}"
  }
}

resource "aws_alb" "backend" {
  # Underscore is not allowed in ALB name
  name               = "devops-demoapp-${var.environment}-backend"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnet_ids
  security_groups    = [aws_security_group.backend_alb.id]

  tags = {
    Name      = "${var.project}-${var.environment}-backend-alb"
    ManagedBy = "${var.iac_tool}"
  }
}

resource "aws_lb_listener" "backend" {
  load_balancer_arn = aws_alb.backend.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.id
  }

  tags = {
    Name      = "${var.project}-${var.environment}-backend-listener"
    ManagedBy = "${var.iac_tool}"
  }
}
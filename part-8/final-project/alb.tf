# ALB (Application Load Balancer)
resource "aws_lb" "application_load_balancer" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_security_group.id]
  subnets            = [
    aws_subnet.public_subnet.id,
    aws_subnet.private_subnet_a.id
  ]
  enable_deletion_protection = false
  tags = {
    Name = "AppLoadBalancer"
  }
}

# ALB Listener
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "fixed-response"
    fixed_response {
      status_code = 200
      content_type = "text/plain"
      message_body = "Healthy"
    }
  }
}

# ALB Target Group
resource "aws_lb_target_group" "application_target_group" {
  name     = "application-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main_vpc.id
  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
  tags = {
    Name = "AppTargetGroup"
  }
}

# Attach EC2 Instances to Target Group
resource "aws_lb_target_group_attachment" "web_server1_attachment" {
  target_group_arn = aws_lb_target_group.application_target_group.arn
  target_id        = aws_instance.web_server1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "web_server2_attachment" {
  target_group_arn = aws_lb_target_group.application_target_group.arn
  target_id        = aws_instance.web_server2.id
  port             = 80
}

# ALB Listener Rule
resource "aws_lb_listener_rule" "forward_to_target_group" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 100
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.application_target_group.arn
  }
  condition {
    path_pattern {
      values = ["/"]
    }
  }
}
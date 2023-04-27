# --- loadbalancing/main.tf ---


# INTERNET FACING LOAD BALANCER

resource "aws_lb" "three_tier_alb" {
  name               = "three_tier_loadbalancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.three_tier_alb.id]
  subnets            = var.public_subnets

  #enable_deletion_protection = true

#   access_logs {
#     bucket  = aws_s3_bucket.lb_logs.id
#     prefix  = "test-lb"
#     enabled = true
#   }

  tags = {
    Environment = "testenv"
  }
}

#ALB target group
resource "aws_lb_target_group" "three_tier_tg" {
  name     = "tf-threetier-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

depends_on = [vpc_id]

}

#attach tg to instance
resource "aws_lb_target_group_attachment" "tg_attach1" {
  target_group_arn = aws_lb_target_group.three_tier_tg.arn
  target_id        = aws_instance.my-machine-0.id
  port             = 80
  depends_on = [aws_instance.my-machine-0]
}


resource "aws_lb_target_group_attachment" "tg_attach2" {
  target_group_arn = aws_lb_target_group.three_tier_tg.arn
  target_id        = aws_instance.my-machine-1.id
  port             = 80

  depends_on = [aws_instance.my-machine-1]
}

#ALB group
resource "aws_lb_listener" "listener_lb" {
  load_balancer_arn = aws_lb.listener_lb.arn
  port              = "80"
  protocol          = "HTTP"
  #ssl_policy        = "ELBSecurityPolicy-2016-08"
  #certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.three_tier_tg.arn
  }
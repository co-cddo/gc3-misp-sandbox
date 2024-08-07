#################################################################################################
# This file describes the Load Balancer resources: ALB, ALB target group, ALB listener
#################################################################################################

#Defining the Application Load Balancer
resource "aws_alb" "application_load_balancer80" {
  name               = "phhmisp-alb80"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
  security_groups    = [aws_security_group.alb_sg.id]
}
#Defining the target group and a health check on the application
resource "aws_lb_target_group" "target_group80" {
  name        = "phhmisp-tg80"
  port        = "80"
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.vpc.id
  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 5
    timeout             = 5
    interval            = 30
  }
}
#Defines a Listener for the ALB
resource "aws_lb_listener" "listener80" {
  load_balancer_arn = aws_alb.application_load_balancer80.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group80.arn
  }
}


#Defining the Application Load Balancer
resource "aws_alb" "application_load_balancer443" {
  name               = "phhmisp-alb443"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
  security_groups    = [aws_security_group.alb_sg.id]
}
#Defining the target group and a health check on the application
resource "aws_lb_target_group" "target_group443" {
  name        = "phhmisp-tg443"
  port        = "443"
  protocol    = "HTTPS"
  target_type = "ip"
  vpc_id      = aws_vpc.vpc.id
  health_check {
    path                = "/"
    protocol            = "HTTPS"
    matcher             = "200"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 5
    timeout             = 5
    interval            = 30
  }
}
#Defines a Listener for the ALB
resource "aws_lb_listener" "listener443" {
  load_balancer_arn = aws_alb.application_load_balancer443.arn
  port              = "443"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group443.arn
  }
}


#Defining the Application Load Balancer
resource "aws_alb" "application_load_balancer8080" {
  name               = "phhmisp-alb8080"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
  security_groups    = [aws_security_group.alb_sg.id]
}
#Defining the target group and a health check on the application
resource "aws_lb_target_group" "target_group8080" {
  name        = "phhmisp-tg8080"
  port        = "8080"
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.vpc.id
  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 5
    timeout             = 5
    interval            = 30
  }
}
#Defines a Listener for the ALB
resource "aws_lb_listener" "listener8080" {
  load_balancer_arn = aws_alb.application_load_balancer8080.arn
  port              = "8080"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group8080.arn
  }
}


#Defining the Application Load Balancer
resource "aws_alb" "application_load_balancer50" {
  name               = "phhmisp-alb50"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
  security_groups    = [aws_security_group.alb_sg.id]
}
#Defining the target group and a health check on the application
resource "aws_lb_target_group" "target_group50" {
  name        = "phhmisp-tg50"
  port        = "50000"
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.vpc.id
  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 5
    timeout             = 5
    interval            = 30
  }
}
#Defines a Listener for the ALB
resource "aws_lb_listener" "listener50" {
  load_balancer_arn = aws_alb.application_load_balancer50.arn
  port              = "50"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group50.arn
  }
}





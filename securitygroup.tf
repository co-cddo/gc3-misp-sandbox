# ------------------------------------------------------------------------------
# Security Group for ECS app
# ------------------------------------------------------------------------------
resource "aws_security_group" "ecs_sg" {
  vpc_id                 = aws_vpc.vpc.id
  name                   = "phhmisp-sg-ecs"
  description            = "Security group for ecs app"
  revoke_rules_on_delete = true
  tags = {
    Name = "phhmisp-ECS-sg"
  }
}
# ------------------------------------------------------------------------------
# ECS app Security Group Rules - INBOUND
# ------------------------------------------------------------------------------
resource "aws_vpc_security_group_ingress_rule" "ecs_alb_ingress" {
  #  from_port                    = 0
  #  to_port                      = 0
  ip_protocol                  = "-1"
  description                  = "Allow inbound traffic from ALB"
  security_group_id            = aws_security_group.ecs_sg.id
  referenced_security_group_id = aws_security_group.alb_sg.id
}
# ------------------------------------------------------------------------------
# ECS app Security Group Rules - OUTBOUND
# ------------------------------------------------------------------------------
resource "aws_vpc_security_group_egress_rule" "ecs_all_egress" {
  #  from_port         = 0
  #  to_port           = 0
  ip_protocol       = "-1"
  description       = "Allow outbound traffic from ECS"
  security_group_id = aws_security_group.ecs_sg.id
  cidr_ipv4         = "0.0.0.0/0"
}

# ------------------------------------------------------------------------------
# Security Group for alb
# ------------------------------------------------------------------------------
resource "aws_security_group" "alb_sg" {
  vpc_id                 = aws_vpc.vpc.id
  name                   = "phhmisp-sg-alb"
  description            = "Security group for alb"
  revoke_rules_on_delete = true
  tags = {
    Name = "phhmisp-sg-alb"
  }
}
# ------------------------------------------------------------------------------
# Alb Security Group Rules - INBOUND
# ------------------------------------------------------------------------------
resource "aws_vpc_security_group_ingress_rule" "alb_ingress_all" {
  ip_protocol       = "-1"
  description       = "Allow inbound traffic from internet"
  security_group_id = aws_security_group.alb_sg.id
  #  referenced_security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4 = "0.0.0.0/0"
}
resource "aws_vpc_security_group_ingress_rule" "alb_ingress_http" {
  from_port         = 80
  to_port           = 80
  ip_protocol       = "TCP"
  description       = "Allow inbound traffic from internet"
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
}
resource "aws_vpc_security_group_egress_rule" "alb_ingress_https" {
  from_port         = 443
  to_port           = 443
  ip_protocol       = "TCP"
  description       = "Allow https inbound traffic from internet"
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
}

# ------------------------------------------------------------------------------
# Alb Security Group Rules - OUTBOUND
# ------------------------------------------------------------------------------
resource "aws_vpc_security_group_egress_rule" "alb_egress" {
  #  from_port         = 0
  #  to_port           = 0
  ip_protocol       = "-1"
  description       = "Allow outbound traffic from alb"
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
}
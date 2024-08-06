resource "aws_efs_file_system" "phhmisp_efs" {
  creation_token = "phhmisp-efs"
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
  tags = {
    Name = "phhmisp-efs"
  }
}

resource "aws_efs_mount_target" "phhmisp_efs_pri1_mount_ecs" {
  #  for_each        = toset(["subnet-3c6f1655", "subnet-62ff7a18", "subnet-4b498107"]) # Replace with your subnets
  subnet_id       = aws_subnet.private_subnet_1.id
  file_system_id  = aws_efs_file_system.phhmisp_efs.id
  security_groups = [aws_security_group.ecs_sg.id]
}
resource "aws_efs_mount_target" "phhmisp_efs_pri2_mount_ecs" {
  #  for_each        = toset(["subnet-3c6f1655", "subnet-62ff7a18", "subnet-4b498107"]) # Replace with your subnets
  subnet_id       = aws_subnet.private_subnet_2.id
  file_system_id  = aws_efs_file_system.phhmisp_efs.id
  security_groups = [aws_security_group.ecs_sg.id]
}

#resource "aws_efs_mount_target" "phhmisp_efs_pri1_mount_alb" {
#  #  for_each        = toset(["subnet-3c6f1655", "subnet-62ff7a18", "subnet-4b498107"]) # Replace with your subnets
#  subnet_id       = aws_subnet.public_subnet_1.id
#  file_system_id  = aws_efs_file_system.phhmisp_efs.id
#  security_groups = [aws_security_group.alb_sg.id]
#}
#resource "aws_efs_mount_target" "phhmisp_efs_pri2_mount_alb" {
#  #  for_each        = toset(["subnet-3c6f1655", "subnet-62ff7a18", "subnet-4b498107"]) # Replace with your subnets
#  subnet_id       = aws_subnet.public_subnet_2.id
#  file_system_id  = aws_efs_file_system.phhmisp_efs.id
#  security_groups = [aws_security_group.alb_sg.id]
#}

#resource "aws_efs_mount_target" "phhmisp_efs_mount_alb" {
#  #  for_each        = toset(["subnet-3c6f1655", "subnet-62ff7a18", "subnet-4b498107"]) # Replace with your subnets
#  for_each        = toset(data.aws_subnets.vpc-subnets.ids)
#  file_system_id  = aws_efs_file_system.phhmisp_efs.id
#  subnet_id       = each.value
#  security_groups = [aws_security_group.alb_sg.id]
#}
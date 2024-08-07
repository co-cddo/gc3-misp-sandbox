##########################################################################################
# This file describes the ECS resources: ECS cluster, ECS task definition, ECS service
##########################################################################################

#ECS cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "phhmisp-cluster"
}

#The Task Definition used in conjunction with the ECS service
resource "aws_ecs_task_definition" "task_definition" {
  family                   = "phhmisp-family"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024"
  memory                   = "3072"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  container_definitions = jsonencode([
    {
      name      = "mysql",
      image     = "mariadb:11.4",
      essential = true,
      cpu       = 512,
      memory    = 1024,
      environment = [
        { name = "MYSQL_DATABASE", value = "misp" },
        { name = "MYSQL_USER", value = "misp" },
        { name = "MYSQL_PASSWORD", value = "password" },
        { name = "MYSQL_ROOT_PASSWORD", value = "password" }
      ],
      mountPoints = [
        { sourceVolume = "mysql_data", containerPath = "/var/lib/mysql", readOnly = false }
      ],
      portMappings = [
        { name = "mariadb-3306-tcp", containerPort = 3306, hostPort = 3306, protocol = "tcp", appProtocol = "http" }
      ],
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/phhmisp"
          "awslogs-region"        = "eu-west-2"
          "awslogs-stream-prefix" = "mariadb"
          "awslogs-create-group"  = "true"
        }
      }
    },
    {
      name      = "redis",
      image     = "redis:7.2",
      essential = true,
      mountPoints = [
        { sourceVolume = "redis_data", containerPath = "/data" }
      ],
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/phhmisp"
          "awslogs-region"        = "eu-west-2"
          "awslogs-stream-prefix" = "redis"
          "awslogs-create-group"  = "true"
        }
      }
    },
    {
      name      = "misp-modules",
#      image     = "ghcr.io/misp/misp-docker/misp-modules:5ef80d3",
      image     = "ghcr.io/nukib/misp-modules:latest",
      essential = true,
      #      capDrop   = ["NET_RAW", "SYS_CHROOT", "MKNOD", "NET_BIND_SERVICE", "AUDIT_WRITE", "SETFCAP"],
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/misp"
          "awslogs-region"        = "eu-west-2"
          "awslogs-stream-prefix" = "modules"
          "awslogs-create-group"  = "true"
        }
      }
    },
    {
      name  = "misp",
#      image = "ghcr.io/misp/misp-docker/misp-core:5ef80d3",
      image = "ghcr.io/nukib/misp:latest",
      dependsOn = [
        { containerName = "mysql", condition = "START" },
        { containerName = "redis", condition = "START" }
      ],
      essential = true,
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/misp"
          "awslogs-region"        = "eu-west-2"
          "awslogs-stream-prefix" = "misp"
          "awslogs-create-group"  = "true"
        }
      },
      environment = [
        { name = "MYSQL_HOST", value = "localhost" },
        { name = "MYSQL_LOGIN", value = "misp" },
        { name = "MYSQL_PASSWORD", value = "password" },
        { name = "MYSQL_DATABASE", value = "misp" },
        { name = "REDIS_HOST", value = "localhost" },
        { name = "MISP_BASEURL", value = "http://localhost:8080" },
        { name = "MISP_UUID", value = "0a674a5a-c4cb-491d-80cf-5adb48b5c1cd" },
        { name = "MISP_ORG", value = "Testing org" },
        { name = "MISP_MODULE_URL", value = "http://misp-modules" },
        { name = "MISP_EMAIL", value = "paul.hallam@digital.cabinet-office.gov.uk" },
        { name = "SECURITY_SALT", value = "PleaseChangeForProduction" },
        { name = "ZEROMQ_ENABLED", value = "yes" },
        { name = "SYSLOG_ENABLED", value = "no" },
        { name = "ECS_LOG_ENABLED", value = "yes" },
        { name = "MISP_DEBUG", value = "yes" }
      ],
      #      mountPoints = [
      #        { sourceVolume = "misp_logs", containerPath = "/var/www/MISP/app/tmp/logs/" },
      #        { sourceVolume = "misp_certs", containerPath = "/var/www/MISP/app/files/certs/" },
      #        { sourceVolume = "misp_attachments", containerPath = "/var/www/MISP/app/attachments/" },
      #        { sourceVolume = "misp_img_orgs", containerPath = "/var/www/MISP/app/files/img/orgs/" },
      #        { sourceVolume = "misp_img_custom", containerPath = "/var/www/MISP/app/files/img/custom/" },
      #        { sourceVolume = "misp_gnupg", containerPath = "/var/www/MISP/.gnupg/" }
      #      ],
      mountPoints = [
        { sourceVolume = "misp_logs", containerPath = "misp_logs" },
        { sourceVolume = "misp_certs", containerPath = "mimsp_certs" },
        { sourceVolume = "misp_attachments", containerPath = "misp_attachments" },
        { sourceVolume = "misp_img_orgs", containerPath = "misp_img_orgs" },
        { sourceVolume = "misp_img_custom", containerPath = "misp_img_custom" },
        { sourceVolume = "misp_gnupg", containerPath = "misp_gnupg" }
      ],
      portMappings = [
        { name = "phhmisp-80-tcp", containerPort = 80, hostPort = 80, protocol = "tcp", appProtocol = "http" },
        { name = "phhmisp-8080-tcp", containerPort = 8080, hostPort = 8080, protocol = "tcp", appProtocol = "http" },
        { name = "phhmisp-50000-tcp", containerPort = 50000, hostPort = 50000, protocol = "tcp", appProtocol = "http" }
      ]
    }
    #      ],
    #      capDrop = ["NET_RAW", "SYS_CHROOT", "MKNOD", "AUDIT_WRITE", "SETFCAP"]
    #    }
  ])
  volume {
    name = "mysql_data"
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.phhmisp_efs.id
    }
  }
  volume {
    name = "redis_data"
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.phhmisp_efs.id
    }
  }
  volume {
    name = "misp_logs"
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.phhmisp_efs.id
    }
  }
  volume {
    name = "misp_certs"
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.phhmisp_efs.id
    }
  }
  volume {
    name = "misp_attachments"
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.phhmisp_efs.id
    }
  }
  volume {
    name = "misp_img_orgs"
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.phhmisp_efs.id
    }
  }
  volume {
    name = "misp_img_custom"
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.phhmisp_efs.id
    }
  }
  volume {
    name = "misp_gnupg"
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.phhmisp_efs.id
    }
  }
}

#The ECS service described. This resources allows you to manage tasks
resource "aws_ecs_service" "ecs_service" {
  name                = "phhmisp-ecs-service"
  cluster             = aws_ecs_cluster.ecs_cluster.arn
  task_definition     = aws_ecs_task_definition.task_definition.arn
  launch_type         = "FARGATE"
  scheduling_strategy = "REPLICA"
  desired_count       = 0 # the number of tasks you wish to run

  network_configuration {
    subnets          = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
    assign_public_ip = true
    security_groups  = [aws_security_group.ecs_sg.id, aws_security_group.alb_sg.id]
  }

  # This block registers the tasks to a target group of the loadbalancer.
  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn #the target group defined in the alb file
    container_name   = "misp"
    container_port   = var.container_port
  }
  depends_on = [aws_lb_listener.listener]

  service_registries {
    registry_arn = aws_service_discovery_service.phhmisp.arn
  }

}

resource "aws_service_discovery_private_dns_namespace" "phhmisp" {
  name        = "phhmisp.local"
  vpc         = aws_vpc.vpc.id
  description = "Private DNS namespace for the misp service"
}

resource "aws_service_discovery_service" "phhmisp" {
  name = "phhmisp-ecs-service"
  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.phhmisp.id
    dns_records {
      ttl  = 60
      type = "A"
    }
  }
  health_check_custom_config {
    failure_threshold = 2
  }
}
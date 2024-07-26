terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

data "aws_ecr_authorization_token" "auth" {}

#resource "docker_registry" "aws_ecr" {
#  name     = "aws"
#  username = data.aws_ecr_authorization_token.auth.user_name
#  password = data.aws_ecr_authorization_token.auth.password
#}

resource "null_resource" "docker_build2" {
  triggers = {
    uuid = uuid()
  }
  provisioner "local-exec" {
    command = <<EOT
    #!/bin/bash
    curl https://raw.githubusercontent.com/NUKIB/misp/main/docker-compose.yml -o docker-compose.yml
    docker-compose -f docker-compose.yml -p misp-project create
    docker image ls
    docker tag ghcr.io/nukib/misp:latest         891377055542.dkr.ecr.eu-west-2.amazonaws.com/misp:latest
    docker tag ghcr.io/nukib/misp-modules:latest 891377055542.dkr.ecr.eu-west-2.amazonaws.com/misp/misp-modules:latest
    docker tag mariadb:latest                    891377055542.dkr.ecr.eu-west-2.amazonaws.com/misp/mariadb:latest
    docker tag redis:latest                      891377055542.dkr.ecr.eu-west-2.amazonaws.com/misp/redis:latest
    aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin 891377055542.dkr.ecr.eu-west-2.amazonaws.com
    docker push 891377055542.dkr.ecr.eu-west-2.amazonaws.com/misp:latest
    docker push 891377055542.dkr.ecr.eu-west-2.amazonaws.com/misp/misp-modules:latest
    docker push 891377055542.dkr.ecr.eu-west-2.amazonaws.com/misp/mariadb:latest
    docker push 891377055542.dkr.ecr.eu-west-2.amazonaws.com/misp/redis:latest
#    docker image tag "ghcr.io/nukib/misp:latest" "ghcr.io/nukib/misp:latest"
#    docker image push ${var.ecr_url}:ghcr.io/nukib/misp:latest
#    docker push ${var.ecr_url}:latest
#    docker tag misp:latest  ${var.ecr_url}:latest
    EOT
  }
# depends_on = [aws_ecr_repository.my_repo]
}

resource "docker_image" "misp" {
  name          = "${var.ecr_url}:latest"
  keep_locally  = false
  pull_triggers = ["${data.aws_ecr_authorization_token.auth.proxy_endpoint}"]
}

#resource "docker_container" "misp" {
#  image   = docker_image.misp.latest
#  name    = "misp_container"
#  restart = "always"
#  ports {
#    internal = 80
#    external = 8080
#  }
#}

#resource "docker_network" "my_network" {
#  name = "my_network"
#}

#resource "docker_volume" "my_volume" {
#  name = "my_volume"
#}

resource "null_resource" "docker_build" {
  triggers = {
    uuid = uuid()
  }
  provisioner "local-exec" {
    command = <<EOT
    #!/bin/bash
    curl https://raw.githubusercontent.com/NUKIB/misp/main/docker-compose.yml -o docker-compose.yml
    docker-compose -f docker-compose.yml create
    docker push ${var.ecr_url}:latest
    docker tag misp:latest  ${var.ecr_url}:latest
    EOT
  }
# depends_on = [aws_ecr_repository.my_repo]
}

#    aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin ${var.ecr_url}
#    docker-compose -f https://raw.githubusercontent.com/NUKIB/misp/main/docker-compose.yml build
#    docker push ${var.ecr_url}:latest
#    docker tag misp:latest  ${var.ecr_url}:latest

#      docker build -t my-app:latest .
#      docker tag my-app:latest ${aws_ecr_repository.my_repo.repository_url}:latest
#      docker push ${aws_ecr_repository.my_repo.repository_url}:latest
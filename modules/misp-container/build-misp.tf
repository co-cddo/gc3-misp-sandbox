

#locals {
#  ecr_repo  = "demo"                                                           # ECR repo name
#  image_tag = "latest"                                                         # image tag

#  dkr_img_src_path = "${path.module}/docker-src"
#  dkr_img_src_sha256 = sha256(join("", [for f in fileset(".", "${local.dkr_img_src_path}/**") : file(f)]))

#  dkr_build_cmd = <<-EOT
#    #!/bin/bash
#    curl https://raw.githubusercontent.com/NUKIB/misp/main/docker-compose.yml -o docker-compose.yml
#    docker-compose -f docker-compose.yml create
#    docker push ${var.ecr_url}:latest
##    docker tag misp:latest  ${var.ecr_url}:latest

#        docker build -t ${local.ecr_reg}/${local.ecr_repo}:${local.image_tag} \
#            -f ${local.dkr_img_src_path}/Dockerfile .

#        aws --profile ${local.aws_profile} ecr get-login-password --region ${local.aws_region} | \
#            docker login --username AWS --password-stdin ${local.ecr_reg}

#        docker push ${local.ecr_reg}/${local.ecr_repo}:${local.image_tag}
#    EOT

#}

resource "null_resource" "docker_build" {
  triggers = {
    uuid = uuid()
  }
  provisioner "local-exec" {
    command = <<EOT
    #!/bin/bash
    curl https://raw.githubusercontent.com/NUKIB/misp/main/docker-compose.yml -o docker-compose.yml
    docker-compose -f docker-compose.yml -p misp-project create
    docker push ${var.ecr_url}
#    docker push ${var.ecr_url}:latest
#    docker tag misp:latest  ${var.ecr_url}:latest
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
#################################################################################################
# This file describes the ECR resources: ECR repo, ECR policy, resources to build and push image
#################################################################################################

##Creation of the ECR repo
#resource "aws_ecrpublic_repository" "ecr" {
#    repository_name = "phhmisp-repo"
#}

##The ECR policy describes the management of images in the repo
#resource "aws_ecr_lifecycle_policy" "ecr_policy" {
#  repository = aws_ecrpublic_repository.ecr.repository_name
#  policy     = local.ecr_policy
#}

#This is the policy defining the rules for images in the repo
locals {
  account_id = "891377055542"
  ecr_policy = jsonencode({
    "rules" : [
      {
        "rulePriority" : 1,
        "description" : "Expire images older than 14 days",
        "selection" : {
          "tagStatus" : "any",
          "countType" : "sinceImagePushed",
          "countUnit" : "days",
          "countNumber" : 14
        },
        "action" : {
          "type" : "expire"
        }
      }
    ]
  })
}

##The commands below are used to build and push a docker image of the application in the app folder
locals {
  docker_login_command = "aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${local.account_id}.dkr.ecr.${var.region}.amazonaws.com"
  # docker_login_command = "aws ecr get-login-password --region ${var.region} --profile personal| docker login --username AWS --password-stdin ${local.account_id}.dkr.ecr.${var.region}.amazonaws.com"
  #  docker_build_command              = "docker build -t ${aws_ecr_repository.ecr.name} ./app"
  #  docker_tag_command                = "docker tag ${aws_ecr_repository.ecr.name}:latest ${local.account_id}.dkr.ecr.${var.region}.amazonaws.com/${aws_ecr_repository.ecr.name}:latest"
  #  docker_push_command               = "docker push ${local.account_id}.dkr.ecr.${var.region}.amazonaws.com/${aws_ecr_repository.ecr.name}:latest"
}

#This resource authenticates you to the ECR service
resource "null_resource" "docker_login" {
  provisioner "local-exec" { command = local.docker_login_command }
  triggers = { "run_at" = timestamp() }
  #  depends_on = [aws_ecrpublic_repository.ecr]
}

resource "aws_ecr_repository" "misp" {
  name                 = "misp"
  image_scanning_configuration {
    scan_on_push = true
  }
}
resource "aws_ecr_repository" "misp-modules" {
  name                 = "misp-modules"
  image_scanning_configuration {
    scan_on_push = true
  }
}
resource "aws_ecr_repository" "redis" {
  name                 = "redis"
  image_scanning_configuration {
    scan_on_push = true
  }
}
resource "aws_ecr_repository" "mariadb" {
  name                 = "mariadb"
  image_scanning_configuration {
    scan_on_push = true
  }
}
##This resource builds the docker image from the Dockerfile in the app folder
#resource "null_resource" "docker_build" {
#    provisioner "local-exec" { command     = local.docker_build_command }
#    triggers     =           { "run_at"    = timestamp() }
#    depends_on   =           [ null_resource.docker_login ]
#}

#This resource tags the image 
#resource "null_resource" "docker_tag" {
#    provisioner "local-exec" { command     = local.docker_tag_command  }
#    triggers     =           { "run_at"    = timestamp() }
#    depends_on   =           [ null_resource.docker_build ]
#}

#This resource pushes the docker image to the ECR repo
#resource "null_resource" "docker_push" {
#    provisioner "local-exec" { command     = local.docker_push_command }
#    triggers     =           { "run_at"    = timestamp() }
#    depends_on   =           [ null_resource.docker_tag ]
#}



data "aws_iam_policy_document" "ecr_access_permission_policy" {
  statement {
    sid    = "allow ecr access policy"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["891377055542"]
    }
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeRepositories",
      "ecr:GetRepositoryPolicy",
      "ecr:ListImages",
      "ecr:DeleteRepository",
      "ecr:BatchDeleteImage",
      "ecr:SetRepositoryPolicy",
      "ecr:DeleteRepositoryPolicy",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
  }
}

resource "aws_ecr_repository_policy" "repo_mariadb" {
  repository = "mariadb"
  policy     = data.aws_iam_policy_document.ecr_access_permission_policy.json
}
resource "aws_ecr_repository_policy" "repo_redis" {
  repository = "redis"
  policy     = data.aws_iam_policy_document.ecr_access_permission_policy.json
}
resource "aws_ecr_repository_policy" "repo_phh-misp" {
  repository = "misp"
  policy     = data.aws_iam_policy_document.ecr_access_permission_policy.json
}
resource "aws_ecr_repository_policy" "repo_phh-misp-modules" {
  repository = "misp-modules"
  policy     = data.aws_iam_policy_document.ecr_access_permission_policy.json
}

resource "aws_ecr_repository" "misp_repository" {
    name = var.ecr_name
}

output "repository_url" {
    value = aws_ecr_repository.misp_repository.repository_url
}
resource "aws_ecr_repository" "misp_repository" {
    name = "misp"
}

output "repository_url" {
    value = aws_ecr_repository.misp_repository.repository_url
}
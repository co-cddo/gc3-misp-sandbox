output "misp-fg-vpc" {
    value       = aws_vpc.misp-fg
    description = "MISP fargate cluster VPC"
}
output "misp-fg-subnet1" {
    value = aws_subnet.misp-fg-subnet1
}
output "misp-fg-subnet2" {
    value = aws_subnet.misp-fg-subnet2
}
output "misp-fg-igw" {
    value = aws_internet_gateway.misp-fg-igw
}
output "misp-fg-rt" {
    value = aws_route_table.misp-fg-rt
}


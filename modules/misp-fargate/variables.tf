variable "default_tags" {
    type = map
    description = "Set of default tags"
}
variable "region" {
    type    = string
    default = "eu-west-2"
}
variable "environment" {
    type = string
    default = "sandbox"
}
variable "cluster_name" {
    type = string
}
variable "service_name" {
    type = string
}
variable "vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
}
variable "numb_azs" {
    type = number
    default = 3
}
variable "container_name" {
    type = string
    default = ""
}
variable "container_port" {
    type = string
    default = "80"
}

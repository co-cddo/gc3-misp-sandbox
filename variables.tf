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

variable "tfstate_bucket" {
    type    = string
    default = "gccc-misp-tfstate"
}
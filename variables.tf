variable "default_tags" {
    type = map
    description = "Set of default tags"
}

variable "region" {
    type    = string
    default = "eu-west-2"
}

variable "tfstate_bucket" {
    type    = string
    default = "gccc-misp-tfstate"
}
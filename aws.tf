provider "aws" {
  region = "eu-west-2"
  default_tags {
    tags = var.default_tags
  }
}

#terraform {
#  backend "s3" {
#    bucket = "cddo-supporting-infrastructure-tfstate"
#    key    = "cddo-misp-dev.tfstate"
#    region = "eu-west-2"
#  }
#}

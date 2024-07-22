provider "aws" {
  region = "eu-west-2"
  default_tags {
    tags = var.default_tags
  }
}
#testing
#terraform {
#  backend "s3" {
#    bucket = "cddo-supporting-infrastructure-tfstate"
#    key    = "cddo-misp-dev.tfstate"
#    region = "eu-west-2"
#  }
#}

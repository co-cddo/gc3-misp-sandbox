terraform {
  backend "s3" {
    bucket         = "gccc-misp-tfstate"
    key            = "aws_dynamodb_table.hash_key"
    dynamodb_table = "gccc-misp-tfstate-table"
    encrypt        = true
    region         = "eu-west-2"
  }
}
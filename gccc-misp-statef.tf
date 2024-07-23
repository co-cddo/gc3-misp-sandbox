terraform {
  backend "s3" {
    bucket = "gccc-misp-tfstate"
    key    = "aws_dynamodb_table.hash_key"
  }
}
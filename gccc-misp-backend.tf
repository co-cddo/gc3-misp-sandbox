terraform {
  backend "s3" {
    bucket         = "gccc-misp-sandbox-tfstate"
    key            = "misp.hash_key"
    dynamodb_table = "gccc-misp-tfstate-table"
    encrypt        = true
    region         = "eu-west-2"
  }
}
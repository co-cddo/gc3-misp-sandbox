provider "aws" {
  region = var.region
  default_tags {
    tags = var.default_tags
  }
}

data "terraform_remote_state" "statefile" {
  backend = "s3"
  config = {
    bucket         = "gccc-misp-tfstate"
    key            = "aws_dynamodb_table.hash_key"
    dynamodb_table = "gccc-misp-tfstate-table"
  }
}

resource "aws_iam_openid_connect_provider" "githubOidc" {
 url = "https://token.actions.githubusercontent.com"
 client_id_list = [
   "sts.amazonaws.com"
 ]
 thumbprint_list = ["1c58a3a8518e8759bf075b76b750d4f2df264fcd","6938fd4d98bab03faadb97b34396831e3780aea1"]
}

#
# Add the role that will allow the githubv user to connect and run the actions.
#
data "aws_iam_policy_document" "github_allow" {
 statement {
   effect  = "Allow"
   actions = ["sts:AssumeRoleWithWebIdentity"]
   principals {
     type        = "Federated"
     identifiers = [aws_iam_openid_connect_provider.githubOidc.arn]
   }
   condition {
     test     = "StringLike"
     variable = "token.actions.githubusercontent.com:sub"
#    values   = ["repo:${GitHubOrg}/${GitHubRepo}:*"]
     values   = ["repo:co-cddo/gc3-misp-sandbox:*"]
   }
   condition {
     test     = "StringEquals"
     variable = "token.actions.githubusercontent.com:aud"
     values   = ["sts.amazonaws.com"]
   }
 }
}
resource "aws_iam_role" "github_role" {
  name               = "GithubActionsRole"
  assume_role_policy = data.aws_iam_policy_document.github_allow.json
}

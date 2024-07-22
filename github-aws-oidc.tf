resource "aws_iam_openid_connect_provider" "githubOidc" {
 url = "https://token.actions.githubusercontent.com"

 client_id_list = [
   "sts.amazonaws.com"
 ]

 thumbprint_list = ["a031c46782e6e6c662c2c87c76da9aa62ccabd8e"]
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
     values   = ["repo:${GitHubOrg}/${GitHubRepo}:*"]
   }
   condition {
     test     = "StringEquals"
     variable = "token.actions.githubusercontent.com:aud"
     values   = "sts.amazonaws.com"
   }
 }
}
resource "aws_iam_role" "github_role" {
  name               = "GithubActionsRole"
  assume_role_policy = data.aws_iam_policy_document.github_allow.json
}

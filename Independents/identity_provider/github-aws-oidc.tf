provider "aws" {
  region = "eu-west-2"
  default_tags {
    tags = var.default_tags
  }
}
#
# This section ensures that terraform will attempt to store state file in aws s3 with locking managed by the use of DynamoDB table entries. 
#
terraform {
  backend "s3" {
    bucket         = "gccc-misp-sandbox-tfstate"
    key            = "aws_identity.hash_key"
    dynamodb_table = "gccc-misp-tfstate-table"
    encrypt        = true
    region         = "eu-west-2"
  }
}

#
# This section will import the state file created when the bucket and dynamodb state file management was created 
#
data "terraform_remote_state" "statefile" {
  backend = "s3"
  config = {
    bucket         = "gccc-misp-${var.environment}-tfstate"
    key            = "aws_dynamodb_table.hash_key"
    dynamodb_table = "gccc-misp-tfstate-table"
  }
}

#
# These commands will create the AWS IAM Identity Provider which will allow github (url) to connect using the oidc infoirmation identiti=ed by the two thumbprints.
# Note that these thumbprints have been known to change so if issues occurr this would be a good place to look.
#
resource "aws_iam_openid_connect_provider" "githubOidc" {
 url = "https://token.actions.githubusercontent.com"
 client_id_list = [
   "sts.amazonaws.com"
 ]
 thumbprint_list = ["1c58a3a8518e8759bf075b76b750d4f2df264fcd","6938fd4d98bab03faadb97b34396831e3780aea1"]
}

#
# Add the role that will allow the github user to connect from the repopsitory/branch and run the actions.
# This will need changing to modify the branch name for dev / test and production.
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

#
# The following create the policy role ecsTaskExecutionRole role necessary for Fargate 
# We also add the following policies:
# 
#
# Create an IAM Policy with the necessary permissions
resource "aws_iam_policy" "github_role_policy_mgmt" {
  name        = "RoleManagementPolicy"
  description = "Policy to allow role creation and management"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement: [
      {
        Effect: "Allow",
        Action: [
          "iam:CreateRole",
          "iam:AttachRolePolicy",
          "iam:PutRolePolicy",
          "iam:PassRole",
          "iam:ListRolePolicies",
          "iam:ListAttachedRolePolicies",
          "iam:GetRole",
          "iam:GetRolePolicy"
        ],
        Resource: "*"
      }
    ]
  })
}

# Attach the necessary policy to the role
resource "aws_iam_role_policy_attachment" "github_role_mgmt_policy_attachment" {
  role       = aws_iam_role.github_role.name
  policy_arn = aws_iam_policy.github_role_policy_mgmt.arn
}

#
# Now attach a policy to S3 so that the github actions can update the state files.
#
resource "aws_iam_policy" "statef_bucket_policy" {
  name        = "github-statef-bucket-policy"
  path        = "/"
  description = "Allow "

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:DeleteObject"
        ],
        "Resource" : [
          "arn:aws:s3:::*/*",
          "arn:aws:s3:::gccc-misp-sandbox-tfstate"
        ]
      },
      {
        "Sid" : "dynamodb0",
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:*"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "statef_bucket_policy" {
  role       = aws_iam_role.github_role.name
  policy_arn = aws_iam_policy.statef_bucket_policy.arn
}

#
# Now add the policy that will allow the github user to access ecr, ecs, alb and efs
#
resource "aws_iam_policy" "fargate_policy" {
  name        = "github-fargate-policy"
  path        = "/"
  description = "Allow management of efs, ecs, ecr and alb"
  policy      = file("fargate_policy.json")
}

# Attach the necessary policy to the role
resource "aws_iam_role_policy_attachment" "fargate_policy" {
  role       = aws_iam_role.github_role.name
  policy_arn = aws_iam_policy.fargate_policy.arn
}

#
# Now add the policy that will allow the github user to add VPC infrastructure
#
resource "aws_iam_policy" "vpc_policy" {
  name        = "github-vpc-policy"
  path        = "/"
  description = "Allow management of efs, ecs, ecr and alb"
  policy      = file("vpc_policy.json")
}

# Attach the necessary policy to the role
#
resource "aws_iam_role_policy_attachment" "vpc_policy" {
  role       = aws_iam_role.github_role.name
  policy_arn = aws_iam_policy.vpc_policy.arn
}


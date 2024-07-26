# gc3-misp-sandbox

Before proceeding ensure the instructions in the parent folder to setup the statefile management has been completed.

This folder contains the code needed to create the AWS IAM Identity provider and role to be used by GitHub for secure access when performing github actions to modify the container and/or infrastructure.

OIDC Setup is documented by AWS here
https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc.html

The code :

Ensure that terraform will attempt to store a state file for this section in aws s3 with locking managed by the use of DynamoDB table entries. 

Will import the state file created when the bucket and dynamodb state file management was created 

Create the AWS IAM Identity Provider which will allow github (url) to connect using the oidc infoirmation identified by the two thumbprints.
Note that these thumbprints have been known to change so if issues occurr this would be a good place to look.

Add the role that will allow the github user to connect from the repopsitory/branch and run the actions.
This will need changing to modify the branch name for dev / test and production.

To build:

cd Independents/identity-provider
terraform init
terraform plan
terraform apply




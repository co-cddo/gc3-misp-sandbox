# gc3-misp-sandbox
MISP 

### 1 To create the state file management used by these procedures:

# Initialise the statefile management
cd Independents/setup-statef
mv Now_move_statef.tf Now_move_statef.tf-saved
terraform init
terraform plan
terraform apply

# Have terraform move the statefile to the AWS.
mv Now_move_statef.tf-saved Now_move_statef.tf
terraform init

### 2 Set up the GitHub / AWS identity provider.

OIDC Setup is documented by AWS here
https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc.html

cd Independents/identity-provider
terraform init
terraform plan
terraform apply

### 3 build the infrastructure
Now working on the github actions




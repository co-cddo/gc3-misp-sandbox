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

Initially we have tried the Docker image focused on high performance and security based on CentOS Stream 8 maintained by National Cyber and Information Security Agency of the Czech Republic.

Now we are trying the production ready docker images for MISP and MISP-modules maintained by Stefano Ortolani from VMware. 
Images are regularly pushed to MISP GitHub Package registry (https://github.com/misp/misp-docker) and a blog post with step by step instruction is available at https://blogs.vmware.com/security/2023/01/how-to-deploy-a-threat-intelligence-platform-in-your-data-center.html


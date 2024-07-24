#!/bin/bash

ECR_REPO_URL = $(terraform output -raw repository_url)
IMAGE_TAG="latest"

aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin $ECR_REPO_URL

docker compose build
docker tag misp:latest $ECR_REPO_URL:$IMAGE_TAG

chmod +x misp_build_container.sh
./misp_build_container.sh

  


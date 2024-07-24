#!/bin/bash

ECR_REPO_URL = $(terraform output -raw repository_url)
IMAGE_TAG="latest"

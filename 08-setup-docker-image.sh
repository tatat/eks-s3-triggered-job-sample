#!/bin/bash

cd job

IMAGE_NAME="$STACK_NAME-job"
IMAGE_BASE_URL="$(aws sts get-caller-identity --output text | awk '{ print $1 }').dkr.ecr.$(aws configure get region).amazonaws.com"

docker build -t "$IMAGE_NAME" .
docker tag "${IMAGE_NAME}:latest" "${IMAGE_BASE_URL}/${IMAGE_NAME}:latest"
docker push "${IMAGE_BASE_URL}/${IMAGE_NAME}:latest"

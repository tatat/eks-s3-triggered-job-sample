#!/bin/bash

REGION=$(aws configure get region)
ECR_SECRET_NAME="$STACK_NAME-$REGION-ecr-registry"
IMAGE_NAME="$STACK_NAME-job"
IMAGE_BASE_URL="$(aws sts get-caller-identity --output text | awk '{ print $1 }').dkr.ecr.$REGION.amazonaws.com"
DOCKER_IMAGE="${IMAGE_BASE_URL}/${IMAGE_NAME}:latest"

LAYER_ARN="$(
  aws cloudformation describe-stacks \
    --stack-name "$STACK_NAME-lambda-layer-kubectl" \
    --query 'Stacks[0].Outputs[?OutputKey==`LayerVersionArn`].OutputValue' \
    --output text
)"

sam deploy \
  --stack-name "$STACK_NAME" \
  --s3-bucket "$DEPLOYMENT_BUCKET" \
  --parameter-overrides \
    LayerArn="$LAYER_ARN" \
    DockerImage="$DOCKER_IMAGE" \
    EcrSecretName="$ECR_SECRET_NAME" \
    ObjectSuffix="$OBJECT_SUFFIX" \
    DeploymentBucket="$DEPLOYMENT_BUCKET" \
    DataBucketName="$DATA_BUCKET_NAME" \
  --capabilities CAPABILITY_IAM

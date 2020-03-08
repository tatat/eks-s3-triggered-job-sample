#!/bin/bash

APP_ID='arn:aws:serverlessrepo:us-east-1:903779448426:applications/lambda-layer-kubectl'
LATEST_VERSION=$(aws serverlessrepo get-application --application-id ${APP_ID} --query 'Version.SemanticVersion' --output text)

TEMPLATE_URL="$(
  aws serverlessrepo create-cloud-formation-template \
    --application-id  ${APP_ID} \
    --semantic-version ${LATEST_VERSION} \
    --query "TemplateUrl" \
    --output text
)"

mkdir -p tmp
curl -o tmp/lambda-layer-kubectl.yml "$TEMPLATE_URL"

aws cloudformation deploy \
  --template-file tmp/lambda-layer-kubectl.yml \
  --stack-name "$STACK_NAME-lambda-layer-kubectl" \
  --capabilities CAPABILITY_AUTO_EXPAND \
  --parameter-overrides \
    LayerName=lambda-layer-kubectl

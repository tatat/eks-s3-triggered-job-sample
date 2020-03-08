#!/bin/bash

CLUSTER_NAME="$STACK_NAME-cluster"

eksctl utils associate-iam-oidc-provider --cluster "$CLUSTER_NAME" --approve

POLICY_ARN="$(
  aws cloudformation describe-stacks \
    --stack-name "$STACK_NAME" \
    --query 'Stacks[0].Outputs[?OutputKey==`S3BucketPolicy`].OutputValue' \
    --output text
)"

eksctl create iamserviceaccount \
  --name job \
  --cluster "$CLUSTER_NAME" \
  --attach-policy-arn "$POLICY_ARN" \
  --override-existing-serviceaccounts \
  --approve

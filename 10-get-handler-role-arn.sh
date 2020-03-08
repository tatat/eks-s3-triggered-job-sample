#!/bin/bash

aws cloudformation describe-stacks \
  --stack-name "$STACK_NAME" \
  --query 'Stacks[0].Outputs[?OutputKey==`HandlerFunctionIamRole`].OutputValue' \
  --output text

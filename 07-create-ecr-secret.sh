#!/bin/bash

ACCOUNT=$(aws sts get-caller-identity --output text | awk '{ print $1 }')
REGION=$(aws configure get region)
SECRET_NAME="$STACK_NAME-$REGION-ecr-registry"
TOKEN=$(aws ecr --region=$REGION get-authorization-token --output text --query authorizationData[].authorizationToken | base64 -d | cut -d: -f2)

kubectl delete secret --ignore-not-found $SECRET_NAME

kubectl create secret docker-registry $SECRET_NAME \
 --docker-server=https://${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com \
 --docker-username=AWS \
 --docker-password="${TOKEN}"

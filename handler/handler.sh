#!/bin/bash

set -e

EVENT_DATA="$1"
BUCKET_NAME="$(echo "$EVENT_DATA" | jq -r '.Records[0].s3.bucket.name')"
OBJECT_KEY="$(echo "$EVENT_DATA" | jq -r '.Records[0].s3.object.key')"

kubectl delete job job --ignore-not-found

kubectl create -f - <<EOS
apiVersion: batch/v1
kind: Job
metadata:
  name: job
spec:
  template:
    spec:
      imagePullSecrets:
        - name: $ECR_SECRET_NAME
      containers:
        - name: job
          image: $DOCKER_IMAGE
          imagePullPolicy: Always
          env:
            - name: BUCKET_NAME
              value: $BUCKET_NAME
            - name: OBJECT_KEY
              value: $OBJECT_KEY
      serviceAccountName: job
      restartPolicy: Never
  backoffLimit: 0
EOS

# eks-s3-triggered-job-sample

## Requirements

- kubectl
- eksctl
- docker
- awscli
- aws-sam-cli
- direnv

## Setup

### Set environments

- `AWS_PROFILE`
- `OBJECT_SUFFIX`
- `DEPLOYMENT_BUCKET`
- `DATA_BUCKET`
- `STACK_NAME`

```
$EDITOR .envrc
```

### Create deployment bucket

```sh
./01-create-deployment-bucket.sh
```

### Create ECR for the job

```sh
./02-create-ecr.sh
```

### Create cluster

```sh
./03-create-cluster.sh
```

### Setup aws-lambda-layer-kubectl

```sh
./04-setup-aws-lambda-layer-kubectl.sh
```

### Deploy SAM

```sh
./05-deploy-sam.sh
```

### Login

```sh
./06-login.sh
```

### Create ECR Secret

```sh
./07-create-ecr-secret.sh
```

### Setup the docker image for the job

```sh
./08-setup-docker-image.sh
```

### Create IAM Service Account

```sh
./09-create-iamserviceaccount.sh
```

### Allow handler to use kubectl

```sh
kubectl edit configmap -n kube-system aws-auth
```

And add to `mapRoles` as follows

```yaml
mapRoles:
  - groups:
      - system:masters
    rolearn: $HANDLER_ROLE_ARN
    username: handler
```

`$HANDLER_ROLE_ARN` is result of `./10-get-handler-role-arn.sh`

### Run the job

```
echo 'hi.' > tmp/sample.txt
aws s3 cp tmp/sample.txt s3://$(./11-get-bucket-name.sh)/sample.txt
kubectl get pods
kubectl logs job/job
```

#!/bin/bash

eksctl create cluster --name "$STACK_NAME-cluster" --fargate

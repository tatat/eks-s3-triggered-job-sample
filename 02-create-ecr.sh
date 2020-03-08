#!/bin/bash

aws ecr create-repository --repository-name "$STACK_NAME-job"

#!/usr/bin/env bash
aws ecr get-login-password --region ${REGION}| docker login --username AWS --password-stdin $AWS_ACCOUNT.dkr.ecr.$REGION.amazonaws.com/bot
docker tag bot:$BUILD_TAG $AWS_ACCOUNT.dkr.ecr.$REGION.amazonaws.com/bot:$BUILD_TAG
docker push $AWS_ACCOUNT.dkr.ecr.$REGION.amazonaws.com/bot:$BUILD_TAG'
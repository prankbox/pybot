# aws lambda create-function \
#         --region "$REGION" \
#         --role arn:aws:iam::"$AWS_ACCOUNT":role/"$ROLE_NAME" \
#         --function-name lambda-bot \
#         --package-type Image \
#         --environment "Variables={TELEGRAM_TOKEN=$TELEGRAM_BOT_KEY}" \
#         --code ImageUri="$AWS_ACCOUNT".dkr.ecr."$REGION".amazonaws.com/bot:"$BUILD_TAG"

cd  terraform/lambda
terraform init
terraform apply --auto-approve
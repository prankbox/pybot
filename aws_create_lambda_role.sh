aws iam create-role --role-name "$ROLE_NAME" --assume-role-policy-document file://policy.json
aws iam attach-role-policy --role-name "$ROLE_NAME" --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole
sleep 5
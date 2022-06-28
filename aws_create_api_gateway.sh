#!/usr/bin/env bash
cd terraform
terraform init
terraform apply --auto-approve
BASE_URL=$(terraform output -raw base_url)
curl --request POST --url "https://api.telegram.org/bot$TELEGRAM_BOT_KEY/setWebhook" --header 'content-type: application/json' --data '{"url": "$BASE_URL"}'
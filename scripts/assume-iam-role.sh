#!/bin/bash

set -euo pipefail

TIMESTAMP=$(date -u +"%Y%m%dT%H%M%SZ")
AWS_CREDS_FILE=/tmp/$2-$TIMESTAMP.json
AWS_SESSION_DURATION=900

aws sts assume-role \
    --role-arn $1 \
    --role-session-name $2-session \
    --duration-seconds $AWS_SESSION_DURATION \
    --output json >$AWS_CREDS_FILE

if [[ ! -v AWS_ACCESS_KEY_ID ]]; then
    echo "AWS_ACCESS_KEY_ID is not set"
elif [[ -z "$AWS_ACCESS_KEY_ID" ]]; then
    echo "AWS_ACCESS_KEY_ID is set to the empty string"
else
    echo "AWS_ACCESS_KEY_ID has the value: $AWS_ACCESS_KEY_ID"
    unset AWS_ACCESS_KEY_ID
fi

export AWS_ACCESS_KEY_ID=$(jq -r '.Credentials.AccessKeyId' $AWS_CREDS_FILE)

if [[ ! -v AWS_SECRET_ACCESS_KEY ]]; then
    echo "AWS_SECRET_ACCESS_KEY is not set"
elif [[ -z "$AWS_SECRET_ACCESS_KEY" ]]; then
    echo "AWS_SECRET_ACCESS_KEY is set to the empty string"
else
    echo "AWS_SECRET_ACCESS_KEY has a value"
    unset AWS_SECRET_ACCESS_KEY
fi

export AWS_SECRET_ACCESS_KEY=$(jq -r '.Credentials.SecretAccessKey' $AWS_CREDS_FILE)

if [[ ! -v AWS_SESSION_TOKEN ]]; then
    echo "AWS_SESSION_TOKEN is not set"
elif [[ -z "$AWS_SESSION_TOKEN" ]]; then
    echo "AWS_SESSION_TOKEN is set to the empty string"
else
    echo "AWS_SESSION_TOKEN has a value"
    unset AWS_SESSION_TOKEN
fi

export AWS_SESSION_TOKEN=$(jq -r '.Credentials.SessionToken' $AWS_CREDS_FILE)

echo $AWS_CREDS_FILE
rm $AWS_CREDS_FILE

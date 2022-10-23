#!/bin/bash

# Assume IAM Role
#
# Usage: source ./scripts/assume-iam-role.sh <IAM role ARN> <session-prefix>
#
# Dependencies: The script requires Bash 4 or above and the AWS CLI
#

# Add -x to enable debugging output
set -eu -o pipefail

ROLE_SESSION_ID=$(</dev/urandom head -c 16 | base64 | tr -dc '0-9a-zA-Z')
AWS_SESSION_NAME=$2-$ROLE_SESSION_ID
AWS_SESSION_DURATION=900 # 900 seconds is the minimum value allowed

AWS_CREDS=( $(
    aws sts assume-role \
    --role-arn "$1" \
    --role-session-name "$AWS_SESSION_NAME" \
    --duration-seconds $AWS_SESSION_DURATION \
    --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]' \
    --output text
) )

echo "INFO: Requested session $AWS_SESSION_NAME for IAM role $1"

if [[ ! -v AWS_ACCESS_KEY_ID ]]; then
    :
elif [[ -z "$AWS_ACCESS_KEY_ID" ]]; then
    :
else
    echo "WARN: Replacing AWS_ACCESS_KEY_ID with new key for assumed role"
    unset AWS_ACCESS_KEY_ID
fi

AWS_ACCESS_KEY_ID=${AWS_CREDS[0]}
export AWS_ACCESS_KEY_ID

if [[ ! -v AWS_SECRET_ACCESS_KEY ]]; then
    :
elif [[ -z "$AWS_SECRET_ACCESS_KEY" ]]; then
    :
else
    echo "WARN: Replacing current AWS_SECRET_ACCESS_KEY with new key for assumed role"
    unset AWS_SECRET_ACCESS_KEY
fi

AWS_SECRET_ACCESS_KEY=${AWS_CREDS[1]}
export AWS_SECRET_ACCESS_KEY

if [[ ! -v AWS_SESSION_TOKEN ]]; then
    :
elif [[ -z "$AWS_SESSION_TOKEN" ]]; then
    :
else
    echo "WARN: Replacing current AWS_SESSION_TOKEN with new token for assumed role"
    unset AWS_SESSION_TOKEN
fi

AWS_SESSION_TOKEN=${AWS_CREDS[2]}
export AWS_SESSION_TOKEN

echo "INFO: Assumed IAM role $1 with session $AWS_SESSION_NAME"

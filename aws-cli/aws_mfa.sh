#!/bin/bash
# sh-labs
# create with good vibes by: @chaconmelgarejo
# description: Configure MFA profile in aws/credentials
# requirements: jq package installed - apt/yum install jq
# define vars: output_file
# usage: ./aws_mfa [arn] [token]

token=$2
arn_mfa=$1
output_file=".aws/credentials"
profile="mfa"

aws sts get-session-token --serial-number $arn_mfa --token-code $token \
  --output json > credentials_mfa.txt

access_key=$(jq .Credentials.AccessKeyId credentials_mfa.txt)
secret_key=$(jq .Credentials.SecretAccessKey credentials_mfa.txt)
token_key=$(jq .Credentials.SessionToken credentials_mfa.txt)

echo "" >> $output_file
echo "[$profile]" >> $output_file
echo "aws_access_key_id = ${access_key:1:-1}" >> $output_file
echo "aws_secret_access_key = ${secret_key:1:-1}" >> $output_file
echo "aws_session_token = ${token_key:1:-1}"  >> $output_file
echo "The New MFA access was created with success in $output_file, please use the --profile $profile"

echo "Loading the AWS env vars ..."
export AWS_SDK_LOAD_CONFIG=1
export AWS_PROFILE=$profile
export AWS_ACCESS_KEY_ID=${access_key:1:-1}
export AWS_SECRET_ACCESS_KEY=${secret_key:1:-1}
export AWS_SESSION_TOKEN=${token_key:1:-1}

rm -rf credentials_mfa.txt

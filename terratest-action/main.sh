#!/bin/bash

set -e

function parse_inputs {
  # Mandatory Inputs 

  if [ "${INPUT_SSH_PRIVATE_KEY_ID}" != "" ]; then
    ssh_private_key_id=${INPUT_SSH_PRIVATE_KEY_ID}
  else
    echo "ERROR: SSH PRIVATE key in secrets manager is required"
    exit 1
  fi

  if [ $"{INPUT_IAM_CREDS_ID}" != "" ]; then
    iam_creds_id=${INPUT_IAM_CREDS_ID}
  else
    echo "ERROR: IAM CREDENTIALS id stored in secrets manager is required"
    exit 1
  fi

  if [ "${INPUT_AWS_REGION}" != "" ]; then
    aws_region=${INPUT_AWS_REGION}
  fi

  # Optional

  terratestArgs=${INPUT_TERRATEST_ARGS}


}

function createSSHKeyfile {
  # This function should read the SSH Private key form the secrets manager
  # and write to file under $HOME/.ssh/id_rsa 
  # Also read github.com public key and place it in $HOME/.ssh/known_hosts
  # file. 
  mkdir -p /root/.ssh
  ssh_private_key=$(aws --region ${aws_region} secretsmanager get-secret-value --secret-id ${ssh_private_key_id} --query SecretString --output text)
  cat > /root/.ssh/id_rsa <<-EOF
${ssh_private_key}
EOF
  chmod 0600 /root/.ssh/id_rsa
  ssh-keyscan github.com >> /root/.ssh/known_hosts
}

function awsProfile {
  # This function should read the IAM Credentials from the Secrets manager 
  # and build AWS Profile ~/.aws/ 
  mkdir -p ~/.aws
  touch ~/.aws/credentials
  aws_access_key_id=$(aws --region ${aws_region} secretsmanager get-secret-value --secret-id ${iam_creds_id} --query SecretString --output text | jq -r '.AWS_ACCESS_KEY_ID')
  aws_secret_access_key=$(aws --region ${aws_region} secretsmanager get-secret-value --secret-id ${iam_creds_id} --query SecretString --output text | jq -r '.AWS_SECRET_ACCESS_KEY')
  aws_iam_role=$(aws --region ${aws_region} secretsmanager get-secret-value --secret-id ${iam_creds_id} --query SecretString --output text | jq -r '.AWS_IAM_ROLE_NAME')
  aws_account_id=$(aws --region ${aws_region} secretsmanager get-secret-value --secret-id ${iam_creds_id} --query SecretString --output text | jq -r '.EPHMERICAL')
  echo "[default]
  aws_access_key_id = $aws_access_key_id
  aws_secret_access_key = $aws_secret_access_key
  region = ${aws_region}
  
  [github]
  role_arn = arn:aws:iam::$aws_account_id:role/$aws_iam_role
  source_profile = default" > ~/.aws/credentials 
}

workingDir=test

function main {
  parse_inputs
  createSSHKeyfile
  awsProfile
  
  export AWS_PROFILE=github

  cd $workingDir
  go test -v ${terratestArgs}
}


main "${*}"
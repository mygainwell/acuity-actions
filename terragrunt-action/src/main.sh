#!/bin/bash

function stripColors {
    echo "${1}" | sed 's/\x1b\[[0-9;]*m//g'
}

function hasPrefix {
    case ${2} in
        "${1}"*)
            true
        ;;
        *)
            false
        ;;
    esac
}

function parseInputs {
    
    # Required inputs
    if [ "${INPUT_TF_VERSION}" != "" ]; then
        tfVersion=${INPUT_TF_VERSION}
    else
        echo "Input terraform_version cannot be empty"
        exit 1
    fi
    
    if [ "${INPUT_TG_VERSION}" != "" ]; then
        tgVersion=${INPUT_TG_VERSION}
    else
        echo "Input terragrunt_version cannot be empty"
        exit 1
    fi
    
    if [ "${INPUT_TG_SUBCOMMAND}" != "" ]; then
        tfSubcommand=${INPUT_TG_SUBCOMMAND}
    else
        echo "Input terraform_subcommand cannot be empty"
        exit 1
    fi
    
    if [ "${INPUT_SSH_PRIVATE_KEY}" != "" ]; then
        tfSSHPrivateKey=${INPUT_SSH_PRIVATE_KEY}
    else
        echo "Input terraform_ssh_private_key cannot be empty"
        exit 1
    fi
    if [ "${INPUT_IAM_CREDS_SECRET}" != "" ]; then
        iamCredentials=${INPUT_IAM_CREDS_SECRET}
    else
        echo "Input IAM Credential Secert cannot be empty"
        exit 1
    fi
    # Optional inputs
    tfWorkingDir="."
    if [[ -n "${INPUT_TG_WORKING_DIR}" ]]; then
        tfWorkingDir=${INPUT_TG_WORKING_DIR}
    fi
    
    tfBinary="terragrunt"
    if [[ -n "${INPUT_TG_BINARY}" ]]; then
        tfBinary=${INPUT_TG_BINARY}
    fi
}

function configureSSHKey {
    # This function should SSH Private key stored in AWS Secrets Manager
    # in US-EAST-1 and store the file under the location /root/.ssh
    # Also get the public key of github.com and place it in 
    # /root/.ssh/known_hosts file. 
    echo "Adding SSH Key"
    mkdir -p /root/.ssh
    if [[ ! -f "/root/.ssh/id_rsa" ]] && [[ "${tfSSHPrivateKey}" != "" ]]; then
        ssh_key=$(aws --region us-east-1 secretsmanager get-secret-value --secret-id ${tfSSHPrivateKey} --query SecretString --output text)
        cat > /root/.ssh/id_rsa <<-EOF
${ssh_key}
EOF
        chmod 600 /root/.ssh/id_rsa
        ssh-keyscan github.com >> /root/.ssh/known_hosts
    fi
    
}

function configureIAM {
    # This function should get the IAM credentials stored in secrets Manager
    # in US-EAST-1 and export them as AWS Environment variables. 
    # AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY
    aws --region us-east-1 secretsmanager get-secret-value --secret-id ${iamCredentials} --query SecretString --output text | jq -r 'to_entries|map("\(.key)=\(.value|tostring)")|.[]' > /tmp/secrets.env
    eval $(cat /tmp/secrets.env | sed 's/^/export /')
    rm -f /tmp/secrets.env
}

function installTerraform {
    if [[ "${tfVersion}" == "latest" ]]; then
        echo "Checking the latest version of Terraform"
        tfVersion=$(curl -sL https://releases.hashicorp.com/terraform/index.json | jq -r '.versions[].version' | grep -v '[-].*' | sort -rV | head -n 1)
        
        if [[ -z "${tfVersion}" ]]; then
            echo "Failed to fetch the latest version"
            exit 1
        fi
    fi
    
    url="https://releases.hashicorp.com/terraform/${tfVersion}/terraform_${tfVersion}_linux_amd64.zip"
    
    echo "Downloading Terraform v${tfVersion}"
    curl -s -S -L -o /tmp/terraform_${tfVersion} ${url}
    if [ "${?}" -ne 0 ]; then
        echo "Failed to download Terraform v${tfVersion}"
        exit 1
    fi
    echo "Successfully downloaded Terraform v${tfVersion}"
    
    echo "Unzipping Terraform v${tfVersion}"
    unzip -d /usr/local/bin /tmp/terraform_${tfVersion} &> /dev/null
    if [ "${?}" -ne 0 ]; then
        echo "Failed to unzip Terraform v${tfVersion}"
        exit 1
    fi
    echo "Successfully unzipped Terraform v${tfVersion}"
}

function installTerragrunt {
    if [[ "${tgVersion}" == "latest" ]]; then
        echo "Checking the latest version of Terragrunt"
        latestURL=$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/gruntwork-io/terragrunt/releases/latest)
        tgVersion=${latestURL##*/}
        
        if [[ -z "${tgVersion}" ]]; then
            echo "Failed to fetch the latest version"
            exit 1
        fi
    fi
    
    url="https://github.com/gruntwork-io/terragrunt/releases/download/${tgVersion}/terragrunt_linux_amd64"
    
    echo "Downloading Terragrunt ${tgVersion}"
    curl -s -S -L -o /tmp/terragrunt ${url}
    if [ "${?}" -ne 0 ]; then
        echo "Failed to download Terragrunt ${tgVersion}"
        exit 1
    fi
    echo "Successfully downloaded Terragrunt ${tgVersion}"
    
    echo "Moving Terragrunt ${tgVersion} to PATH"
    chmod +x /tmp/terragrunt
    mv /tmp/terragrunt /usr/local/bin/terragrunt
    if [ "${?}" -ne 0 ]; then
        echo "Failed to move Terragrunt ${tgVersion}"
        exit 1
    fi
    echo "Successfully moved Terragrunt ${tgVersion}"
}

function main {
    # Source the other files to gain access to their functions
    scriptDir=$(dirname ${0})
    source ${scriptDir}/terragrunt_format.sh
    source ${scriptDir}/terragrunt_init.sh
    source ${scriptDir}/terragrunt_validate.sh
    source ${scriptDir}/terragrunt_plan.sh
    source ${scriptDir}/terragrunt_apply.sh
    source ${scriptDir}/terragrunt_apply_run_all.sh
    source ${scriptDir}/terragrunt_output.sh
    source ${scriptDir}/terragrunt_import.sh
    source ${scriptDir}/terragrunt_taint.sh
    source ${scriptDir}/terragrunt_destroy.sh
    
    parseInputs
    installTerraform
    configureSSHKey
    configureIAM
    installTerragrunt

    cd ${GITHUB_WORKSPACE}/${tfWorkingDir}
    echo "${tfSubcommand}"
    case "${tfSubcommand}" in
        format)
            echo "::group::format"
            terragruntFormat ${*}
            echo "::endgroup::"
        ;;
        init)
            echo "::group::init"
            terragruntInit ${*}
            echo "::endgroup::"
        ;;
        validate)
            echo "::group::validate"
            terragruntValidate ${*}
            echo "::endgroup::"
        ;;
        plan)
            echo "::group::plan"
            terragruntPlan ${*}
            echo "::endgroup::"
        ;;
        apply)
            echo "::group::apply"
            terragruntApply ${*}
            echo "::endgroup::"
        ;;
        apply-all)
            echo "::group::apply-all"
            terragruntApplyRunAll ${*}
            echo "::endgroup::"
        ;;        
        output)
            echo "::group::output"
            terragruntOutput ${*}
            echo "::endgroup::"
        ;;
        import)
            echo "::group::import"
            terragruntImport ${*}
            echo "::endgroup::"
        ;;
        taint)
            echo "::group::taint"
            terragruntTaint ${*}
            echo "::endgroup::"
        ;;
        destroy)
            echo "::group::destroy"
            terragruntDestroy ${*}
            echo "::endgroup::"
        ;;
        *)
            echo "Error: Must provide a valid value for terragrunt_subcommand"
            exit 1
        ;;
    esac
}

main "${*}"
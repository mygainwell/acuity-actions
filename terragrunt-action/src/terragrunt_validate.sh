#!/bin/bash

function terragruntValidate {
    # Gather the output of `terragrunt validate`.
    echo "validate: info: validating Terragrunt configuration in ${tfWorkingDir}"
    validateOutput=$(${tfBinary} validate ${*} 2>&1)
    validateExitCode=${?}
    
    # Exit code of 0 indicates success. Print the output and exit.
    if [ ${validateExitCode} -eq 0 ]; then
        echo "validate: info: successfully validated Terragrunt configuration in ${tfWorkingDir}"
        echo "${validateOutput}"
        echo
        exit ${validateExitCode}
    fi
    
    # Exit code of !0 indicates failure.
    echo "validate: error: failed to validate Terragrunt configuration in ${tfWorkingDir}"
    echo "${validateOutput}"
    echo
    
    exit ${validateExitCode}
}

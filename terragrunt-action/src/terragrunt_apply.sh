#!/bin/bash

function terragruntApply {
    # Gather the output of `terragrunt apply`.
    echo "apply: info: applying Terragrunt configuration in ${tfWorkingDir}"
    applyOutput=$(${tfBinary} run-all apply -auto-approve -input=false --terragrunt-non-interactive --terragrunt-include-external-dependencies ${*} 2>&1)
    applyExitCode=${?}
    
    # Exit code of 0 indicates success. Print the output and exit.
    if [ ${applyExitCode} -eq 0 ]; then
        echo "apply: info: successfully applied Terragrunt configuration in ${tfWorkingDir}"
        echo "${applyOutput}"
        echo
    fi
    
    # Exit code of !0 indicates failure.
    if [ ${applyExitCode} -ne 0 ]; then
        echo "apply: error: failed to apply Terragrunt configuration in ${tfWorkingDir}"
        echo "${applyOutput}"
        echo
    fi
    
    exit ${applyExitCode}
}

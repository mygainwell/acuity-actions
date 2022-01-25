#!/bin/bash

function terragruntFormat {
    # Gather the output of `terragrunt format`.
    echo "format: info: format Terragrunt configuration in ${tfWorkingDir}"
    formatOutput=$(${tfBinary} fmt -check ${*} 2>&1)
    formatExitCode=${?}
    
    # Exit code of 0 indicates success. Print the output and exit.
    if [ ${formatExitCode} -eq 0 ]; then
        echo "format: info: successfully formated Terragrunt configuration in ${tfWorkingDir}"
        echo "${formatOutput}"
        echo 
        exit ${formatExitCode}
    fi
    
    # Exit code of !0 indicates failure.
    echo "format: error: failed to format Terragrunt configuration in ${tfWorkingDir}"
    echo "${formatOutput}"
    echo
    
    exit ${formatExitCode}
}
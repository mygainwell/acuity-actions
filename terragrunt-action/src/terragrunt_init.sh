#!/bin/bash

function terragruntInit {
    # Gather the output of `terragrunt init`.
    echo "init: info: initializing Terragrunt configuration in ${tfWorkingDir}"
    initOutput=$(${tfBinary} init -input=false ${*} 2>&1)
    initExitCode=${?}
    
    # Exit code of 0 indicates success. Print the output and exit.
    if [ ${initExitCode} -eq 0 ]; then
        echo "init: info: successfully initialized Terragrunt configuration in ${tfWorkingDir}"
        echo "${initOutput}"
        echo
        exit ${initExitCode}
    fi
    
    # Exit code of !0 indicates failure.
    echo "init: error: failed to initialize Terragrunt configuration in ${tfWorkingDir}"
    echo "${initOutput}"
    echo
    
    exit ${initExitCode}
}

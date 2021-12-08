#!/bin/bash

function terragruntTaint {
    # Gather the output of `terragrunt taint`.
    echo "taint: info: tainting terragrunt configuration in ${tfWorkingDir}"
    #taintOutput=$(terragrunt taint ${*} 2>&1)
    taintOutput=$(for resource in ${*}; do ${tfBinary} taint -allow-missing $resource; done 2>&1)
    taintExitCode=${?}
    taintCommentStatus="Failed"
    
    # Exit code of 0 indicates success with no changes. Print the output and exit.
    if [ ${taintExitCode} -eq 0 ]; then
        taintCommentStatus="Success"
        echo "taint: info: successfully tainted Terragrunt configuration in ${tfWorkingDir}"
        echo "${taintOutput}"
        echo
        exit ${taintExitCode}
    fi
    
    # Exit code of !0 indicates failure.
    if [ ${taintExitCode} -ne 0 ]; then
        echo "taint: error: failed to taint Terragrunt configuration in ${tfWorkingDir}"
        echo "${taintOutput}"
        echo
    fi
    
    exit ${taintExitCode}
}

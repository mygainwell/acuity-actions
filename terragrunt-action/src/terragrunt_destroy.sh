#!/bin/bash

function terragruntDestroy {
    # Gather the output of `terragrunt destroy`.
    echo "destroy: info: destroying Terragrunt-managed infrastructure in ${tfWorkingDir}"
    destroyOutput=$(${tfBinary} destroy -auto-approve -input=false ${*} 2>&1)
    destroyExitCode=${?}

    # Exit code of 0 indicates success. Print the output and exit.
    if [ ${destroyExitCode} -eq 0 ]; then
        echo "destroy: info: successfully destroyed Terragrunt-managed infrastructure in ${tfWorkingDir}"
        echo "${destroyOutput}"
        echo 
    fi
    
    # Exit code of !0 indicates failure.
    if [ ${destroyExitCode} -ne 0 ]; then
        echo "destroy: error: failed to destroy Terragrunt configuration in ${tfWorkingDir}"
        echo "${destroyOutput}"
    fi
    
    exit ${destroyExitCode}
}

#!/bin/bash

function terragruntImport {
    # Gather the output of `terragrunt import`.
    echo "import: info: importing Terragrunt configuration in ${tfWorkingDir}"
    importOutput=$(${tfBinary} import -input=false ${*} 2>&1)
    importExitCode=${?}
    
    # Exit code of 0 indicates success with no changes. Print the output and exit.
    if [ ${importExitCode} -eq 0 ]; then
        echo "import: info: successfully imported Terragrunt configuration in ${tfWorkingDir}"
        echo "${importOutput}"
        echo
        exit ${importExitCode}
    fi
    
    # Exit code of !0 indicates failure.
    if [ ${importExitCode} -ne 0 ]; then
        echo "import: error: failed to import Terragrunt configuration in ${tfWorkingDir}"
        echo "${importOutput}"
        echo
    fi
    
    exit ${importExitCode}
}

#!/bin/bash

function terragruntPlan {
    # Gather the output of `terragrunt plan`.
    echo "plan: info: planning Terragrunt configuration in ${tfWorkingDir}"
    planOutput=$(${tfBinary} plan -detailed-exitcode -input=false ${*} 2>&1)
    planExitCode=${?}
    planHasChanges=false
    
    # Exit code of 0 indicates success with no changes. Print the output and exit.
    if [ ${planExitCode} -eq 0 ]; then
        echo "plan: info: successfully planned Terragrunt configuration in ${tfWorkingDir}"
        echo "${planOutput}"
        echo
        echo ::set-output name=tf_plan_has_changes::${planHasChanges}
    fi
    
    # Exit code of 2 indicates success with changes. Print the output, change the
    # exit code to 0, and mark that the plan has changes.
    if [ ${planExitCode} -eq 2 ]; then
        planExitCode=0
        planHasChanges=true
        echo "plan: info: successfully planned Terragrunt configuration in ${tfWorkingDir}"
        echo "${planOutput}"
        echo
        if echo "${planOutput}" | egrep '^-{72}$' &> /dev/null; then
            planOutput=$(echo "${planOutput}" | sed -n -r '/-{72}/,/-{72}/{ /-{72}/d; p }')
        fi
        planOutput=$(echo "${planOutput}" | sed -r -e 's/^  \+/\+/g' | sed -r -e 's/^  ~/~/g' | sed -r -e 's/^  -/-/g')
        
        # If output is longer than max length (65536 characters), keep last part
        planOutput=$(echo "${planOutput}" | head -c 65000 )
    fi
    
    # Exit code of !0 indicates failure.
    if [ ${planExitCode} -ne 0 ]; then
        echo "plan: error: failed to plan Terragrunt configuration in ${tfWorkingDir}"
        echo "${planOutput}"
        echo
    fi
    
    echo ::set-output name=tf_plan_has_changes::${planHasChanges}
    
    # https://github.community/t5/GitHub-Actions/set-output-Truncates-Multiline-Strings/m-p/38372/highlight/true#M3322
    planOutput="${planOutput//'%'/'%25'}"
    planOutput="${planOutput//$'\n'/'%0A'}"
    planOutput="${planOutput//$'\r'/'%0D'}"
    
    echo "::set-output name=tf_plan_output::${planOutput}"
    echo "::set-output name=exitcode::${planExitCode}"
    exit ${planExitCode}
}

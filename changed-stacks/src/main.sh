#!/bin/bash
# INPUT_SOURCE_REF=origin/directory-services
# INPUT_TARGET_REF=origin/main
# INPUT_ENVIRONMENT=mgmt

function parse_inputs {
	if [ -z ${INPUT_SOURCE_REF} ]; then
		echo "ERROR: Source Reference is required"
		exit 1
	else
		source_ref=${INPUT_SOURCE_REF}
	fi

	if [ -z ${INPUT_TARGET_REF} ]; then
		echo "ERROR: Target Reference is required"
		exit 1
	else
		target_ref=${INPUT_TARGET_REF}
	fi

	if [ -z ${INPUT_ENVIRONMENT} ]; then
		echo "ERROR: Environment is Required"
		exit 1
	else
		environment=${INPUT_ENVIRONMENT}
	fi
}

containsElement () {
  local e match="$1"
  shift

  for e; do 
  	[[ "$e" == "$match" ]] && return 0 
  done
  return 1
}

function main {
	echo "Newest Change"

	deploy_all=false
	repo_root=$(git rev-parse --show-toplevel)
	scriptDir=$(dirname ${0})
	updated_folders=${scriptDir}/git-updated-folders
	updated_files=${scriptDir}/git-updated-files

	parse_inputs

	# This returns a list of any stack folder that has changes when comparing source to target
	stack_files_array=( $("$updated_folders" --source-ref "$source_ref" --target-ref "$target_ref" --terragrunt | grep stacks | sed 's|stacks/||g') )
	# This return a list of any stack folder that had a change to it's /input/*.hcl file.
	input_files_array=( $("$updated_files" --source-ref "$source_ref" --target-ref "$target_ref" --ext .hcl --exclude-ext terragrunt.hcl | grep inputs/${environment}/ | grep inputs.hcl | sed "s|inputs/${environment}/||g" | xargs -I {} dirname {}) )
	
	# Get files at common files at root 
	# /inputs/${environment}/${environment}.hcl
	# /common.hcl
	# /stacks/config.hcl	
	
	# TODO: Need to decide on accounts.json
	# "dev.hcl" "prd.hcl" "stg.hcl" "ephem.hcl" "mgmt.hcl" "config.hcl" "common.hcl"
	static_common_files_array=( ${environment}.hcl config.hcl common.hcl)	
	common_files_array=( $("$updated_files" --source-ref "$source_ref" --target-ref "$target_ref" --ext .hcl --exclude-ext terragrunt.hcl | grep 'inputs/mgmt*\|stacks*\|[^\].*[.hcl]' | sed "s/.*\///"))
	
	updated_stacks_array=("${stack_files_array[@]}" "${input_files_array[@]}")

	for file in "${common_files_array[@]}"; do
		containsElement "$file" "${static_common_files_array[@]}"
		if [ $? -eq 0 ]; then
			deploy_all=true
			break
		fi
	done

	if ${deploy_all}; then 
		echo "Listing all stacks in ${environment}, as common confuguration is updated"
		_stacks=$(find "${repo_root}/inputs/${environment}" -type f -name "inputs.hcl" | sed "s|${repo_root}/inputs/${environment}/||g" | xargs -I {} dirname {}) 
		stacks=( $_stacks )
	else
		echo "Building Updated Stacks Array"
		stacks=( $(printf '%s\n' "${updated_stacks_array[@]}" | sort -u) )
	fi

	echo "Stack Files Array: ${stack_files_array[@]}"
	echo "Input Files Array: ${input_files_array[@]}"
	echo "Common Files Array: ${common_files_array[@]}"
	echo "Merge Stacks: ${stacks[@]}"

	JSON="{\"stacks\": ["
	
	for stack in ${stacks[@]}; do
		JSONLine="\"$stack\","
		if [[ "$JSON" != *"$JSONLine"* ]]; then
			JSON="$JSON$JSONLine"
		fi
	done

	if [[ $JSON == *, ]]; then
		JSON=${JSON%?}
	fi
	JSON="$JSON]}"
	echo "::set-output name=stacks::$( echo "$JSON" )"
}

main "${*}"
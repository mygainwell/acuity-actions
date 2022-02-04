setup() {
    load 'test_helper/bats-support/load'
    load 'test_helper/bats-assert/load'
    # ... the remaining setup is unchanged

    # get the containing directory of this file
    # use $BATS_TEST_FILENAME instead of ${BASH_SOURCE[0]} or $0,
    # as those will point to the bats executable's location or the preprocessed file respectively
    DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
    # make executables in src/ visible to PATH
    PATH="$DIR/../src:$PATH"
    export INPUT_SOURCE_REF="source"
    export INPUT_TARGET_REF="target"
    export INPUT_ENVIRONMENT="environment"
}

@test "invoking changed-stacks with nonexistent source prints an error" {
  unset INPUT_SOURCE_REF
  run ./changed-stacks/src/main.sh
  assert_output --partial "ERROR: Source Reference is required"
}

@test "invoking changed-stacks with nonexistent target prints an error" {
  unset INPUT_TARGET_REF
  run ./changed-stacks/src/main.sh
  assert_output --partial "ERROR: Target Reference is required"
}

@test "invoking changed-stacks with nonexistent environment prints an error" {
  unset INPUT_ENVIRONMENT
  run ./changed-stacks/src/main.sh
  assert_output --partial "ERROR: Environment is Required"
}

@test "source to changed-stacks with fake input" {
  source ./changed-stacks/src/main.sh
  updatedStacks=$(updatedStacks)
  ((updatedStacks == null))
}

@test "stack files array filter" {
  source ./changed-stacks/src/main.sh
  updated_folders=("inputs" "inputs/foo" "stacks" "stacks/foo")
  output=$(stack_files_array "${updated_folders[@]}")
  assert_output "inputs inputs/foo stacks foo"
}

@test "input files array filter" {
  export INPUT_ENVIRONMENT="ephem"
  source ./changed-stacks/src/main.sh
  updated_files=("common.hcl" "inputs/ephem/foo/inputs.hcl" "stacks/foo/terragrunt.hcl")
  output=$(input_files_array "${updated_files[@]}")
  assert_output "common.hcl foo/inputs.hcl stacks/foo"
}
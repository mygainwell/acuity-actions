@test "invoking changed-stacks with nonexistent source prints an error" {
  run ./changed-stacks/src/main.sh
  status_errors=(1 126)
  [[ " ${status_errors[*]} " =~ " $status " ]]
  [[ "$output" = "ERROR: Source Reference is required" ]]
}
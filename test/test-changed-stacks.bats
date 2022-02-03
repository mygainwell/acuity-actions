@test "invoking changed-stacks with nonexistent source prints an error" {
  run ./changed-stacks/src/main.sh
  [ "$status" -eq 1 ]
  [ "$output" = "ERROR: Source Reference is required" ]
}
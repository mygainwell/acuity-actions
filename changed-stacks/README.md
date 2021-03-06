# Changed Stacks Action

This action should allow you to identify the Files & Folders changed between the HEAD and BASE and generate a matrix of changed stacks that needs to be deployed into an environment.

If any of the common files are updated its gone run all the stacks in sequence.

## Success Criteria

An exit code of `0` is considered a successful execution.

## Usage

```yaml
name: Changed Stacks
on: [pull_request]

jobs:
  pre-reqs:
    name: 'Terragrunt'
    runs-on: ubuntu-latest
    outputs:
      stacks: ${{ steps.stacks-array.outputs.stacks }}
    steps:
      - name: 'Checkout'
        uses: actions/checkout@master
      - name: changed stacks
        id: stacks-array
        uses: mygainwell/acutiy-actions/changed-stacks
        with:
          # current branch (base)
          source_ref: origin/${{ github.event.pull_request.head.ref }}
          # destination branch of the pull request
          target_ref: origin/${{ github.event.pull_request.base.ref }}
          environment: dev
```

## Inputs

Inputs configure Terraform GitHub Actions to perform different actions.

| Input Name  | Description             | Required | Example     |
| :---------- | :---------------------- | :------: | :---------: |
| source_ref  | Source Reference (HEAD) |  `Yes`   | b668df2     |
| target_ref  | Target Reference (BASE) |  `Yes`   | origin/main |
| environment | Environment             |  `Yes`   |             |

## Outputs

Outputs are used to pass information to subsequent GitHub Actions steps.

| Output Name | Description                      |
| :---------- | :------------------------------- |
| stacks      | List of Stacks that are changed. |

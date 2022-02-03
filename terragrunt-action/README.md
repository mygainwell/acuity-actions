# Terragrunt GitHub Actions

Terragrunt GitHub Actions allow you to execute Terragrunt commands within GitHub Actions.

The output of the actions can be viewed from the Actions tab in the main repository view. If the actions are executed on a pull request event, a comment may be posted on the pull request.

Terragrunt GitHub Actions are a single GitHub Action that executes different Terragrunt subcommands depending on the content of the GitHub Actions YAML file.

## Success Criteria

An exit code of `0` is considered a successful execution.

## Usage

The most common workflow is to run `terragrunt fmt`, `terragrunt init`, `terragrunt validate`, `terragrunt plan`, and `terragrunt taint` on all of the Terragrunt files in the root of the repository when a pull request is opened or updated. A comment will be posted to the pull request depending on the output of the Terragrunt subcommand being executed. This workflow can be configured by adding the following content to the GitHub Actions workflow YAML file. Note that this action will use `terragrunt` binary to run all commands. In case of passing a `terraform` subcommand `terragrunt` will forward it to `terraform`.

```yaml
name: 'Terragrunt GitHub Actions'
on:
  - pull_request
env:
  ssh_private_key: 'github/workflows/sshprivatekey'
  iam_creds_secret: 'github/workflows/iamcreds'
  tf_version: 'latest'
  tg_version: 'latest'
  tf_working_dir: '.'
jobs:
  terragrunt:
    name: 'Terragrunt'
    runs-on: ubuntu-latest
    steps:
      - name: 'Checkout'
        uses: actions/checkout@master
      - name: 'Terragrunt Format'
        uses: mygainwell/terragrunt-action@main
        with:
          ssh_private_key: ${{ env.ssh_private_key }}
          iam_creds_secret: ${{ env.iam_creds_secret }}
          tf_version: ${{ env.tf_version }}
          tg_version: ${{ env.tg_version }}
          tg_subcommand: 'fmt'
          tg_working_dir: ${{ env.tf_working_dir }}
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      - name: 'Terragrunt Init'
        uses: mygainwell/terragrunt-action@main
        with:
          ssh_private_key: ${{ env.ssh_private_key }}
          iam_creds_secret: ${{ env.iam_creds_secret }}
          tf_version: ${{ env.tf_version }}
          tg_version: ${{ env.tg_version }}
          tg_subcommand: 'init'
          tg_working_dir: ${{ env.tf_working_dir }}
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      - name: 'Terragrunt Validate'
        uses: mygainwell/terragrunt-action@main
        with:
          ssh_private_key: ${{ env.ssh_private_key }}
          iam_creds_secret: ${{ env.iam_creds_secret }}
          tf_version: ${{ env.tf_version }}
          tg_version: ${{ env.tg_version }}
          tg_subcommand: 'validate'
          tg_working_dir: ${{ env.tf_working_dir }}
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      - name: 'Terragrunt Plan'
        uses: mygainwell/terragrunt-action@main
        with:
          ssh_private_key: ${{ env.ssh_private_key }}
          iam_creds_secret: ${{ env.iam_creds_secret }}
          tf_version: ${{ env.tf_version }}
          tg_version: ${{ env.tg_version }}
          tg_subcommand: 'plan'
          tg_working_dir: ${{ env.tf_working_dir }}
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

This was a simplified example showing the basic features of these Terragrunt GitHub Actions. Please refer to the examples within the `examples` directory for other common workflows.

## Inputs

Inputs configure Terraform GitHub Actions to perform different actions.

| Input Name       | Description                                                                                                | Required |
| :--------------- | :--------------------------------------------------------------------------------------------------------- | :------: |
| ssh_private_key  | SSH Private key from SecretsManager                                                                        |  `Yes`   |
| iam_creds_secret | IAM Credentials from SecretsManager                                                                        |   `No`   |
| tf_version       | The Terraform version to install and execute. If set to `latest`, the latest stable version will be used.  |  `Yes`   |
| tg_version       | The Terragrunt version to install and execute. If set to `latest`, the latest stable version will be used. |  `Yes`   |
| tg_binary        | The binary to run the commands with                                                                        |   `No`   |
| tg_subcommand    | The Terraform/Terragrunt subcommand to execute.                                                            |   `No`   |
| tg_working_dir   | The working directory to change into before executing Terragrunt subcommands.                              |   `No`   |

## Outputs

Outputs are used to pass information to subsequent GitHub Actions steps.

| Output Name         | Description                                                             |
| :------------------ | :---------------------------------------------------------------------- |
| tf_output           | The Terragrunt outputs in (stringified) JSON format.                    |
| tf_plan_has_changes | `'true'` if the Terragrunt plan contained changes, otherwise `'false'`. |
| tf_plan_output      | The Terragrunt plan output.                                             |

## Secrets

Secrets are similar to inputs except that they are encrypted and only used by GitHub Actions. It's a convenient way to keep sensitive data out of the GitHub Actions workflow YAML file.

- `GITHUB_TOKEN` - (Optional) The GitHub API token used to post comments to pull requests. Not required if the `tf_actions_comment` input is set to `false`.

Other secrets may be needed to authenticate with Terraform backends and providers.

**WARNING:** These secrets could be exposed if the action is executed on a malicious Terraform file. To avoid this, it is recommended not to use these Terraform GitHub Actions on repositories where untrusted users can submit pull requests.

## Environment Variables

Environment variables are exported in the environment where the Terraform GitHub Actions are executed. This allows a user to modify the behavior of certain GitHub Actions.

The usual [Terraform environment variables](https://www.terraform.io/docs/commands/environment-variables.html) are supported. Here are a few of the more commonly used environment variables.

- [`TF_LOG`](https://www.terraform.io/docs/commands/environment-variables.html#tf_log)
- [`TF_VAR_name`](https://www.terraform.io/docs/commands/environment-variables.html#tf_var_name)

Other environment variables may be configured to pass data into Terraform. If the data is sensitive, consider using [secrets](#secrets) instead.

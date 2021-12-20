# Terratest Action

This actions run a [terratest](https://terratest.gruntwork.io/) on the modules or stacks. [Github Action Checkout]( https://github.com/actions/checkout) is a pre-requisite to downlead the content of your repo inside the docker. 

## Inputs

- `ssh_private_key_id`: (Required) AWS Secrets Manager path to SSH Private key stored in Management account.

- `iam_creds_id`:  (Required) AWS Secrets Manager path to IAM Credentials stored in Management Account.

- `aws_account_ids`: (Required) AWS Secrets Manager path to AWS Account IDs stored in Management Account, Currently only `EPHEMERICAL` account is only pulled and used by this action. 

- `aws_region`: (Required) AWS Region where AWS Secrets Manager is hosted. 

- `terratest_args`: (Optional) If left blank all tests under working directory are executed. 

- `working_dir`: (Optional) Defaults to `test` Override to any particular folder relative to Repo Home directory. 

## Outputs

None

## Example

```
jobs:
  terratest:
  runs-on: self-hosted
 steps:
	- uses: actions/checkout@v2
	- uses: mygainwell/acuity-actions/terratest-action
	  with:
	    ssh_private_key_id: github/workflow/sshkeys
	    iam_creds_id: github/workflow/iam
	    aws_account_ids: github/workflow/aws
	    aws_region: us-east-1
	    terratest_args: -v *_test.go
	    working_dir: test
```




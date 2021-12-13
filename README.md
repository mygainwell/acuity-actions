# acuity-actions

Custom GitHub Actions used within Acuity

## Testing with [ACT](https://github.com/nektos/act#example-commands)

```bash
choco install act-cli
```

results:

```bash
Chocolatey v0.11.3
Installing the following packages:
act-cli
By installing, you accept licenses for the packages.
act-cli v0.2.24 already installed. Forcing reinstall of version '0.2.24'.
 Please use upgrade if you meant to upgrade to a new version.
Progress: Downloading act-cli 0.2.24... 100%

act-cli v0.2.24 (forced) [Approved]
act-cli package files install completed. Performing other installation steps.
 ShimGen has successfully created a shim for act.exe
 The install of act-cli was successful.
  Software install location not explicitly set, it could be in package or
  default install location of installer.

Chocolatey installed 1/1 packages.
 See the log for details (C:\ProgramData\chocolatey\logs\chocolatey.log).
```

Run your GitHub Actions locally

```bash
act
```

Test shell scripts with BATS
```
./test/bats/bin/bats test
```

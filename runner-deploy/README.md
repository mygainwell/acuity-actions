# Action Runners

install docker machine

```bash
base=https://github.com/docker/machine/releases/download/v0.16.2 &&
  mkdir -p "$HOME/bin" &&
  curl -L $base/docker-machine-Windows-x86_64.exe > "$HOME/bin/docker-machine.exe" &&
  chmod +x "$HOME/bin/docker-machine.exe"
```

configure aws credentials and assume role

```bash
aws configure
```

assume the GithubRunnerRole

```bash
aws sts assume-role --role-arn "arn:aws:iam::800782569207:role/GithubRunnerRole" --role-session-name AWSCLI-Session
```

create the machine and ssh into it

```bash
docker-machine create \
    --driver amazonec2 \
    --amazonec2-region "us-east-1" \
    --amazonec2-root-size "16" \
    --engine-install-url "https://releases.rancher.com/install-docker/19.03.9.sh" \
    runner-node

docker-machine ssh runner-node
```

Use `nano` to create the `Dockerfile` and `entrypoint.sh`

```bash
nano Dockerfile
nano entrypoint.sh
```

Build and run the image

```bash
sudo docker build --tag runner-image .

sudo docker run \
  --detach \
  --env ORGANIZATION=$ORGANIZATION \
  --env ACCESS_TOKEN=$ACCESS_TOKEN \
  --name runner \
  runner-image
```

Inspect logs

```bash
sudo docker logs runner -f
```

failure message:

```bash
ubuntu@runner-node:~$ curl -sX POST -H "Authorization: token ${ACCESS_TOKEN}" https://api.github.com/orgs/${ORGANIZATION}/actions/runners/registration-token
{
  "message": "Must have admin rights to Repository.",
  "documentation_url": "https://docs.github.com/rest/reference/actions#create-a-registration-token-for-an-organization"
}
```

Stop the runner

```bash
docker stop runner
```

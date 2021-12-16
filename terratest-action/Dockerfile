FROM ubuntu:latest

ARG TF_VERSION=1.0.11

RUN apt install -y wget curl git python3.8 python3-pip golang-go jq

RUN	pip3 install wheel boto3 awscli

RUN cd /usr/local/bin && wget https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip \
  && unzip terraform_${TF_VERSION}_linux_amd64.zip  && rm terraform_${TF_VERSION}_linux_amd64.zip

ENTRYPOINT ["main.sh"]
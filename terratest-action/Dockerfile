FROM alpine:3

ENV GLIBC_VER=2.31-r0
ENV PATH="/usr/local/go/bin:${PATH}"
ENV TERRAFORM_VERSION=1.0.11

RUN apk --no-cache add \
  binutils \
  curl \
  && curl -sL https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub \
  && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-${GLIBC_VER}.apk \
  && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-bin-${GLIBC_VER}.apk \
  && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-i18n-${GLIBC_VER}.apk \
  && apk add --no-cache \
  glibc-${GLIBC_VER}.apk \
  glibc-bin-${GLIBC_VER}.apk \
  glibc-i18n-${GLIBC_VER}.apk \
  && /usr/glibc-compat/bin/localedef -i en_US -f UTF-8 en_US.UTF-8 \
  && curl -sL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip \
  && unzip awscliv2.zip \
  && aws/install \
  && rm -rf \
  awscliv2.zip \
  aws \
  /usr/local/aws-cli/v2/*/dist/aws_completer \
  /usr/local/aws-cli/v2/*/dist/awscli/data/ac.index \
  /usr/local/aws-cli/v2/*/dist/awscli/examples \
  glibc-*.apk \
  && apk --no-cache del \
  binutils \
  curl \
  && rm -rf /var/cache/apk/*

RUN ["/bin/sh", "-c", "apk add --update --no-cache bash build-base ca-certificates curl git jq openssh"]

RUN cd /usr/local/bin && \
  curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
  unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
  rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

COPY --from=golang:1.13-alpine /usr/local/go/ /usr/local/go/
COPY ["main.sh", "/src/main.sh"]

RUN chmod 0755 /src/main.sh

ENTRYPOINT ["/src/main.sh"]
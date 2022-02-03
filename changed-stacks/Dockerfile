FROM alpine:3

RUN ["/bin/sh", "-c", "apk add --update --no-cache bash ca-certificates curl git jq openssh binutils curl sudo findutils"]

COPY ["src", "/src/"]

RUN ["chmod", "+x", "/src/main.sh"]
RUN ["chmod", "+x", "/src/git-updated-files"]
RUN ["chmod", "+x", "/src/git-updated-folders"]

ENTRYPOINT ["/src/main.sh"]

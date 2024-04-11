# This Dockerfile is used to build the image available on DockerHub
FROM golang:1.21 as build

# Add everything
ADD . /usr/src/multus-cni
RUN  cd /usr/src/multus-cni && \
     ./hack/build-go.sh

FROM alpine:latest

RUN apk update && apk add --no-cache bash

COPY --from=build /usr/src/multus-cni /usr/src/multus-cni
COPY --from=build /usr/src/multus-cni/LICENSE /usr/src/multus-cni/LICENSE

WORKDIR /

RUN apk update && apk add --no-cache yum

ADD ./images/entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

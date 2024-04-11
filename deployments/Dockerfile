# This Dockerfile is used to build the image available on DockerHub
FROM golang:1.21 as build

# Add everything
ADD . /usr/src/multus-cni
RUN  cd /usr/src/multus-cni && \
     ./hack/build-go.sh

FROM centos:centos7
LABEL org.opencontainers.image.source https://github.com/k8snetworkplumbingwg/multus-cni
COPY --from=build /usr/src/multus-cni /usr/src/multus-cni
COPY --from=build /usr/src/multus-cni/LICENSE /usr/src/multus-cni/LICENSE
WORKDIR /
RUN yum update -y

ADD ./images/entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

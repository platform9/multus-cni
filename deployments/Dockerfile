FROM alpine:3.20 as build

ADD . /usr/src/multus-cni
RUN apk add --no-cache git wget bash coreutils
ENV GO_VERSION 1.23.1
RUN wget https://dl.google.com/go/go$GO_VERSION.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go$GO_VERSION.linux-amd64.tar.gz && \
    rm go$GO_VERSION.linux-amd64.tar.gz
ENV PATH="$PATH:/usr/local/go/bin"

RUN cd /usr/src/multus-cni && \
    ./hack/build-go.sh

FROM alpine:3.20
LABEL org.opencontainers.image.source https://github.com/k8snetworkplumbingwg/multus-cni
COPY --from=build /usr/src/multus-cni /usr/src/multus-cni
WORKDIR /
RUN apk add --no-cache git wget bash coreutils python3
ADD ./images/entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

#!/usr/bin/env bash
set -e

DEST_DIR="bin"

if [ ! -d ${DEST_DIR} ]; then
	mkdir ${DEST_DIR}
fi

# Add version/commit/date into binary
# In case of TravisCI, need to check error code of 'git describe'.
if [ -z "$VERSION" ]; then
	set +e
	git describe --tags --abbrev=0 > /dev/null 2>&1
	if [ "$?" != "0" ]; then
		VERSION="master"
	else
		VERSION=$(git describe --tags --abbrev=0)
	fi
	set -e
fi
DATE=$(date -u -d "@${SOURCE_DATE_EPOCH:-$(date +%s)}" --iso-8601=seconds)
COMMIT=${COMMIT:-$(git rev-parse --verify HEAD)}
LDFLAGS="-X gopkg.in/k8snetworkplumbingwg/multus-cni.v4/pkg/multus.version=${VERSION} \
	-X gopkg.in/k8snetworkplumbingwg/multus-cni.v4/pkg/multus.commit=${COMMIT} \
	-X gopkg.in/k8snetworkplumbingwg/multus-cni.v4/pkg/multus.gitTreeState=${GIT_TREE_STATE} \
	-X gopkg.in/k8snetworkplumbingwg/multus-cni.v4/pkg/multus.releaseStatus=${RELEASE_STATUS} \
	-X gopkg.in/k8snetworkplumbingwg/multus-cni.v4/pkg/multus.date=${DATE}"
export CGO_ENABLED=${CGO_ENABLED:-0}

# build with go modules
export GO111MODULE=on

if [ -n "$MODMODE" ]; then
	BUILD_ARGS=(-mod "$MODMODE")
fi

echo "Building multus"
go build -o ${DEST_DIR}/multus ${BUILD_ARGS} -ldflags "${LDFLAGS}" "$@" ./cmd/multus
echo "Building multus-daemon"
go build -o "${DEST_DIR}"/multus-daemon ${BUILD_ARGS} -ldflags "${LDFLAGS}" ./cmd/multus-daemon
echo "Building multus-shim"
go build -o "${DEST_DIR}"/multus-shim ${BUILD_ARGS} -ldflags "${LDFLAGS}" ./cmd/multus-shim
echo "Building install_multus"
go build -o "${DEST_DIR}"/install_multus ${BUILD_ARGS} -ldflags "${LDFLAGS}" ./cmd/install_multus
echo "Building thin_entrypoint"
go build -o "${DEST_DIR}"/thin_entrypoint ${BUILD_ARGS} -ldflags "${LDFLAGS}" ./cmd/thin_entrypoint

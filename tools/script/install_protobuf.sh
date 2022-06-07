#! /bin/bash

## date:    2021-05-17
## author:  duruyao@gmail.com
## desc:    download, build and install protobuf
## release: https://github.com/protocolbuffers/protobuf/releases

## more info see this:
##     https://developers.google.com/protocol-buffers
## compile guide see this:
##     https://github.com/protocolbuffers/protobuf/blob/master/src/README.md

set -euo pipefail

function error_ln() {
  printf "\033[1;32;31m%s\n\033[m" "$1"
}

function warning_ln() {
  printf "\033[1;33m%s\n\033[m" "$1"
}

function info_ln() {
  printf "\033[0;32;32m%s\n\033[m" "$1"
}

function show_usage() {
  cat <<EOF
Usage: bash $0 <INSTALL_PATH>

Download, build and install ${package} (sudo permission maybe required)
EOF
}

function show_usage() {
  cat <<EOF
Usage: bash $0 <INSTALL_PATH>

Download, build and install ${package} (sudo permission maybe required)
EOF
}

cores="$(($(nproc) / 2))"
package="protobuf"
url="https://github.com/protocolbuffers/protobuf/releases/download/v21.1/protobuf-cpp-3.21.1.tar.gz"

if [ ${#} != 1 ]; then
  show_usage >&2
  exit 1
fi

install_path="$1"
mkdir -p "${install_path}"

download_path="/tmp/${package}-$(date | md5sum | head -c 6)"
mkdir -p "${download_path}"

cd "${download_path}"
info_ln "Downloading ${package} from ${url} to ${download_path}"
curl -LSso "${package}".tar.gz "${url}"
tar -zxvf "${package}".tar.gz 1>/dev/null

# shellcheck disable=SC2035
source_path="${PWD}/$(ls -d */)"

cd "${source_path}"
./configure --prefix="${install_path}"
make all --jobs="${cores}"
make check && make install # more available memory maybe required

echo ""
info_ln "Install ${package} to ${install_path}"
if [ -n "$(command -v tree)" ]; then
  tree "${install_path}" -L 1
else
  ls -all "${install_path}"
fi

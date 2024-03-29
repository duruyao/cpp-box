#! /bin/bash

## date:    2021-05-17
## author:  duruyao@gmail.com
## desc:    download, build and install cppzmq
## release: https://github.com/zeromq/cppzmq/releases

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
Usage: bash $0 <INSTALL_PATH> <LIBZMQ_INSTALL_PATH>

Download, build and install ${package} (sudo permission maybe required)
EOF
}

cores="$(($(nproc) / 2))"
package="cppzmq"
url="https://github.com/zeromq/cppzmq/archive/refs/tags/v4.8.1.tar.gz"

if [ ${#} != 2 ]; then
  show_usage >&2
  exit 1
fi

install_path="$1"
libzmq_install_path="$2"
mkdir -p "${install_path}"

download_path="${HOME}/Downloads/${package}"
mkdir -p "${download_path}"

cd "${download_path}"
info_ln "Downloading ${package} from ${url} to ${download_path}"
if [ ! -f "${package}".tar.gz ]; then
  curl -LSso "${package}".tar.gz "${url}"
fi
tar -zxvf "${package}".tar.gz 1>/dev/null

# shellcheck disable=SC2035
source_path="${PWD}/$(ls -d */)"
build_path="${source_path}/build"

cmake -H"${source_path}" -B"${build_path}" \
  -DCPPZMQ_BUILD_TESTS=OFF \
  -DCMAKE_INSTALL_PREFIX="${install_path}" \
  -DCMAKE_PREFIX_PATH="${libzmq_install_path}" \
  -DCMAKE_CXX_FLAGS="-I${libzmq_install_path}/include" \
  -DCMAKE_BUILD_WITH_INSTALL_RPATH=OFF \
  -DCMAKE_INSTALL_RPATH="${install_path}/lib" \
  -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=ON
cmake --build "${build_path}" --target all --jobs="${cores}"
cmake --build "${build_path}" --target install

echo ""
info_ln "Install ${package} to ${install_path}"
if [ -n "$(command -v tree)" ]; then
  tree "${install_path}" -L 1
else
  ls -all "${install_path}"
fi

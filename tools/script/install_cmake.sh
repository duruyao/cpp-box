#! /bin/bash

## date:    2021-05-17
## author:  duruyao@gmail.com
## desc:    download, build and install cmake
## release: https://github.com/Kitware/CMake/releases

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
package="cmake"
url="https://github.com/Kitware/CMake/releases/download/v3.23.2/cmake-3.23.2.tar.gz"

if [ ${#} != 1 ]; then
  show_usage >&2
  exit 1
fi

install_path="$1"
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

cd "${source_path}"
./bootstrap --prefix="${install_path}"
make all --jobs="${cores}"
make install

echo ""
info_ln "Install ${package} to ${install_path}"
if [ -n "$(command -v tree)" ]; then
  tree "${install_path}" -L 1
else
  ls -all "${install_path}"
fi

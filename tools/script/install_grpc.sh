#! /bin/bash

## date:    2021-05-17
## author:  duruyao@gmail.com
## desc:    download, build and install grpc
## release: https://github.com/grpc/grpc/releases

## more info see this:
##     https://grpc.io
## compile guide for C++ see this:
##     https://github.com/grpc/grpc/blob/master/BUILDING.md

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
package="grpc"
tag="v1.46.3"
repository="https://github.com/grpc/grpc"

if [ ${#} != 1 ]; then
  show_usage >&2
  exit 1
fi

## Prerequisites
#apt-get install build-essential autoconf libtool pkg-config cmake git -y

install_path="$1"
mkdir -p "${install_path}"
download_path="${HOME}/Downloads/${package}"
mkdir -p "${download_path}"

cd "${download_path}"
info_ln "Downloading ${package}:${tag} from ${repository} to ${download_path}/${package}-${tag}"
if [ ! -d "${package}-${tag}" ]; then
  git clone -b "${tag}" "${repository}" "${package}-${tag}"
fi
cd "${package}-${tag}"
git submodule update --init

# Install absl
source_path="${PWD}/third_party/abseil-cpp"
build_path="${source_path}/cmake/build"
cmake -H"${source_path}" -B"${build_path}" \
  -DCMAKE_CXX_FLAGS="-std=c++11" \
  -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_SHARED_LIBS=ON \
  -DCMAKE_INSTALL_PREFIX="${install_path}" \
  -DCMAKE_SKIP_BUILD_RPATH=OFF \
  -DCMAKE_BUILD_WITH_INSTALL_RPATH=OFF \
  -DCMAKE_INSTALL_RPATH="${install_path}/lib" \
  -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=ON \
  -DCMAKE_POSITION_INDEPENDENT_CODE=TRUE
cmake --build "${build_path}" --target all --jobs="${cores}"
cmake --build "${build_path}" --target install

# Install c-ares
# If the distribution provides a new-enough version of c-ares,
# this section can be replaced with:
# apt-get install -y libc-ares-dev
source_path="${PWD}/third_party/cares/cares"
build_path="${source_path}/cmake/build"
cmake -H"${source_path}" -B"${build_path}" \
  -DCMAKE_CXX_FLAGS="-std=c++11" \
  -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_SHARED_LIBS=ON \
  -DCMAKE_INSTALL_PREFIX="${install_path}" \
  -DCMAKE_SKIP_BUILD_RPATH=OFF \
  -DCMAKE_BUILD_WITH_INSTALL_RPATH=OFF \
  -DCMAKE_INSTALL_RPATH="${install_path}/lib" \
  -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=ON
cmake --build "${build_path}" --target all --jobs="${cores}"
cmake --build "${build_path}" --target install

# Install protobuf
if [ -z "$(command -v protoc)" ]; then
  source_path="${PWD}/third_party/protobuf/cmake"
  build_path="${source_path}/build"
  cmake -H"${source_path}" -B"${build_path}" \
    -DCMAKE_CXX_FLAGS="-std=c++11" \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_SHARED_LIBS=ON \
    -DCMAKE_INSTALL_PREFIX="${install_path}" \
    -DCMAKE_SKIP_BUILD_RPATH=OFF \
    -DCMAKE_BUILD_WITH_INSTALL_RPATH=OFF \
    -DCMAKE_INSTALL_RPATH="${install_path}/lib" \
    -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=ON \
    -Dprotobuf_BUILD_TESTS=OFF
  cmake --build "${build_path}" --target all --jobs="${cores}"
  cmake --build "${build_path}" --target install
fi

# Install re2
source_path="${PWD}/third_party/re2"
build_path="${source_path}/cmake/build"
cmake -H"${source_path}" -B"${build_path}" \
  -DCMAKE_CXX_FLAGS="-std=c++11" \
  -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_SHARED_LIBS=ON \
  -DCMAKE_INSTALL_PREFIX="${install_path}" \
  -DCMAKE_SKIP_BUILD_RPATH=OFF \
  -DCMAKE_BUILD_WITH_INSTALL_RPATH=OFF \
  -DCMAKE_INSTALL_RPATH="${install_path}/lib" \
  -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=ON \
  -DCMAKE_POSITION_INDEPENDENT_CODE=TRUE
cmake --build "${build_path}" --target all --jobs="${cores}"
cmake --build "${build_path}" --target install

# Install zlib
source_path="${PWD}/third_party/zlib"
build_path="${source_path}/cmake/build"
cmake -H"${source_path}" -B"${build_path}" \
  -DCMAKE_CXX_FLAGS="-std=c++11" \
  -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_SHARED_LIBS=ON \
  -DCMAKE_INSTALL_PREFIX="${install_path}" \
  -DCMAKE_SKIP_BUILD_RPATH=OFF \
  -DCMAKE_BUILD_WITH_INSTALL_RPATH=OFF \
  -DCMAKE_INSTALL_RPATH="${install_path}/lib" \
  -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=ON
cmake --build "${build_path}" --target all --jobs="${cores}"
cmake --build "${build_path}" --target install

# Install grpc
source_path="${PWD}"
build_path="${source_path}/cmake/build"
cmake -H"${source_path}" -B"${build_path}" \
  -DgRPC_INSTALL=ON \
  -DBUILD_SHARED_LIBS=ON \
  -DgRPC_BUILD_TESTS=OFF \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX="${install_path}" \
  -DgRPC_ABSL_PROVIDER=package \
  -DgRPC_CARES_PROVIDER=package \
  -DgRPC_PROTOBUF_PROVIDER=package \
  -DgRPC_RE2_PROVIDER=package \
  -DgRPC_SSL_PROVIDER=package \
  -DgRPC_ZLIB_PROVIDER=package \
  -DCMAKE_SKIP_BUILD_RPATH=OFF \
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

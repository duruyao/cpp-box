#! /bin/bash

## date:    2021.05.17
## file:    compile and install grpc
## author:  duruyao@hikvision.com
## release: https://github.com/grpc/grpc/releases

CONSOLE_COLOR_NONE="\033[m"
CONSOLE_COLOR_RED="\033[1;32;31m"
CONSOLE_COLOR_GREEN="\033[0;32;32m"
CONSOLE_COLOR_YELLOW="\033[0;33m"
CONSOLE_COLOR_MAGENTA="\033[1;35m"
CONSOLE_COLOR_CYAN_BLUE="\033[1;36m"
CONSOLE_COLOR_LIGHT_BLUE="\033[1;32;34m"

function prt_re() {
  printf "${@}"
  printf "${CONSOLE_COLOR_NONE}"
}

function prt_ye() {
  printf "${CONSOLE_COLOR_YELLOW}"
  printf "${@}"
  printf "${CONSOLE_COLOR_NONE}"
}

function prt_gr() {
  printf "${CONSOLE_COLOR_GREEN}"
  printf "${@}"
  printf "${CONSOLE_COLOR_NONE}"
}

function prt_bl() {
  printf "${CONSOLE_COLOR_LIGHT_BLUE}"
  printf "${@}"
  printf "${CONSOLE_COLOR_NONE}"
}

## pre-check

if [ $# == 3 ]; then
  grpc_zip_path="${1}"
  grpc_ins_path="${2}"
  SDK_HOME="${3}"
else
  prt_ye "USAGE (sudo permission may be needed):\n"
  printf "    %s <GRPC_ZIP_PATH> <GRPC_INSTALL_PATH> <SDK_HOME>\n" "${0}"
  exit 1
fi

printf "\n"
prt_gr "Compile and Install gRPC for C++ in Linux\n\n"

printf "More info see this:\n"
prt_bl "    https://grpc.io/\n"
printf "Other releases see this:\n"
prt_bl "    https://github.com/grpc/grpc/releases\n"
printf "Compile guide for C++ see this:\n"
prt_bl "    https://github.com/grpc/grpc/blob/master/BUILDING.md\n\n"

## 1st step

prt_ye "1)\n"
printf "To build gRPC from source, the following tools are needed:\n"

req_app_list=("g++" "make" "cmake" "autoconf" "libtool" "pkg-config" "build-essential")

for req_app in "${req_app_list[@]}"; do
  prt_ye "    %-16s" "${req_app}"
  printf ":	 "

  req_app_path="$(command -v "${req_app}")"
  if [ -z "${req_app_path}" ]; then
    prt_re "NOT FOUND\n"
  else
    printf "\`${req_app_path}\`\n"
  fi
done

printf "On Ubuntu/Debian, you can install them with:\n"
printf "    sudo apt-get install %s\n\n" "${req_app_list[*]}"

## 2nd step

prt_ye "2)\n"
printf "Unzip \`${grpc_zip_path}\` ...\n"

new_folder="$(dirname "${grpc_zip_path}")/grpc_source"

mkdir -p "${new_folder}" && rm -rf "${new_folder:?}/"*
unzip -q "${grpc_zip_path}" -d "${new_folder}"

grpc_src_path="${new_folder}/$(ls "${new_folder}")"

printf "Generate source code to \`${grpc_src_path}\`:\n"
ls "${grpc_src_path}"

printf "\n"

## 3rd step

prt_ye "3)\n"
printf "Compile grpc for C++ ...\n"

mkdir -p "${grpc_ins_path}" && rm -rf "${grpc_ins_path:?}/"*

grpc_build_path="${grpc_src_path}/cmake/build"
mkdir -p "${grpc_build_path}" && cd "${grpc_build_path}" || exit

my_prefix_path="${SDK_HOME}/protobuf;${SDK_HOME}/abseil-cpp;${SDK_HOME}/c-ares;${SDK_HOME}/re2;${SDK_HOME}/zlib"
my_cxx_flags="-I${SDK_HOME}/protobuf/include ${SDK_HOME}/zlib/include" ## (higher version cmake be needed)
my_cmake="${SDK_HOME}/cmake/bin/cmake"

## add rpath for the installed lib

${my_cmake} "${grpc_src_path}" \
  -DgRPC_INSTALL=ON \
  -DBUILD_SHARED_LIBS=ON \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX="${grpc_ins_path}" \
  -DgRPC_ABSL_PROVIDER=package \
  -DgRPC_CARES_PROVIDER=package \
  -DgRPC_PROTOBUF_PROVIDER=package \
  -DgRPC_RE2_PROVIDER=package \
  -DgRPC_SSL_PROVIDER=package \
  -DgRPC_ZLIB_PROVIDER=package \
  -DCMAKE_PREFIX_PATH=${my_prefix_path} \
  -DCMAKE_CXX_FLAGS="${my_cxx_flags}" \
  -DCMAKE_SKIP_BUILD_RPATH=OFF \
  -DCMAKE_BUILD_WITH_INSTALL_RPATH=OFF \
  -DCMAKE_INSTALL_RPATH="${grpc_ins_path}/lib;${SDK_HOME}/re2/lib" \
  -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=ON

${my_cmake} --build "${grpc_build_path}" --target clean
${my_cmake} --build "${grpc_build_path}" --target all -- -j 16
${my_cmake} --build "${grpc_build_path}" --target install

printf "\n"
printf "Install grpc to \`${grpc_ins_path}\`:\n"
ls -all "${grpc_ins_path}"
printf "\n"

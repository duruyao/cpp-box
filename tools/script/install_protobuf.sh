#! /bin/bash

## date:    2021.05.14
## file:    compile and install protobuf
## author:  duruyao@hikvision.com
## release: https://github.com/protocolbuffers/protobuf/releases

CONSOLE_COLOR_NONE="\033[m"
CONSOLE_COLOR_RED="\033[1;32;31m"
CONSOLE_COLOR_GREEN="\033[0;32;32m"
CONSOLE_COLOR_YELLOW="\033[0;33m"
CONSOLE_COLOR_MAGENTA="\033[1;35m"
CONSOLE_COLOR_CYAN_BLUE="\033[1;36m"
CONSOLE_COLOR_LIGHT_BLUE="\033[1;32;34m"

function prt_re() {
  printf "${CONSOLE_COLOR_RED}"
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

if [ $# == 2 ]; then
  protobuf_zip_path="${1}"
  protobuf_ins_path="${2}"
else
  prt_ye "USAGE (sudo permission may be needed):\n"
  printf "    %s <PROTO_ZIP_PATH> <PROTO_INSTALL_PATH>\n" "${0}"
  exit 1
fi

printf "\n"
prt_gr "Compile and Install Protocol Buffers in Linux\n\n"

printf "More info see this:\n"
prt_bl "    https://developers.google.com/protocol-buffers\n"
printf "Other releases see this:\n"
prt_bl "    https://github.com/protocolbuffers/protobuf/releases\n"
printf "Compile guide see this:\n"
prt_bl "    https://github.com/protocolbuffers/protobuf/blob/master/src/README.md\n\n"

## 1st step

prt_ye "1)\n"
printf "To build protobuf from source, the following tools are needed:\n"

req_app_list=("g++" "make" "unzip" "autoconf" "automake" "libtool")

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
printf "Unzip \`${protobuf_zip_path}\` ...\n"

new_folder="$(dirname "${protobuf_zip_path}")/protobuf_source"

mkdir -p "${new_folder}" && rm -rf "${new_folder:?}/"*
unzip -q "${protobuf_zip_path}" -d "${new_folder}"

protobuf_src_path="${new_folder}/$(ls "${new_folder}")"

printf "Generate source code to \`${protobuf_src_path}\`:\n"
ls "${protobuf_src_path}"

printf "\n"

## 3rd step

prt_ye "3)\n"
printf "Compile protobuf ...\n"

mkdir -p "${protobuf_ins_path}" && rm -rf "${protobuf_ins_path:?}/"*
cd "${protobuf_src_path}" || exit

## auto configure
./configure --prefix="${protobuf_ins_path}"

make -j16 && make check
make install ## copy `lib`, `bin`, `include` to destination (sudo permission needed).

printf "\n"
printf "Install protobuf "
prt_ye "($("${protobuf_ins_path}"/bin/protoc --version)) "
printf "to \`${protobuf_ins_path}\`:\n"
ls -all "${protobuf_ins_path}"
printf "\n"

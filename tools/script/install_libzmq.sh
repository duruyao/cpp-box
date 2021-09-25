#! /bin/bash

## date:    2021.06.21
## file:    compile and install libzmq
## author:  duruyao@hikvision.com
## release: https://github.com/zeromq/libzmq/releases

if [ $# != 2 ]; then
  printf "USAGE (sudo permission may be needed):\n"
  printf "    %s <ZIP_PATH> <INSTALL_PATH>\n" "${0}"
  exit 1
fi

zip_path="${1}"
ins_path="${2}"
new_folder="$(dirname "${zip_path}")/libzmq_source"

mkdir -p "${new_folder}" && rm -rf "${new_folder:?}/"*
unzip -q "${zip_path}" -d "${new_folder}"

src_path="${new_folder}/$(ls "${new_folder}")"

mkdir -p "${ins_path}" && rm -rf "${ins_path:?}/"*

build_path=${src_path}/build

mkdir -p "${build_path}" && cd "${build_path}" || exit

cmake .. -DCMAKE_INSTALL_PREFIX="${ins_path}" \
  -DCMAKE_BUILD_WITH_INSTALL_RPATH=OFF \
  -DCMAKE_INSTALL_RPATH="${ins_path}/lib" \
  -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=ON

make -j16 install

printf "\n"
printf "Install libzmq to \`${ins_path}\`:\n"
ls -all "${ins_path}"
printf "\n"

#! /bin/bash

## date:    2021.05.31
## file:    compile and install cmake
## author:  duruyao@hikvision.com
## release: https://cmake.org/download/

if [ $# != 2 ]; then
  printf "USAGE (sudo permission may be needed):\n"
  printf "    %s <TAR_GZ_PATH> <INSTALL_PATH>\n" "${0}"
  exit 1
fi

zip_path="${1}"
ins_path="${2}"
new_folder="$(dirname "${zip_path}")/cmake_source"

mkdir -p "${new_folder}" && rm -rf "${new_folder:?}/"*
tar -xf "${zip_path}" -C "${new_folder}"

src_path="${new_folder}/$(ls "${new_folder}")"

mkdir -p "${ins_path}" && rm -rf "${ins_path:?}/"*
cd "${src_path}" || exit

./bootstrap --prefix="${ins_path}"
make -j16 && make install

printf "\n"
printf "Install cmake to \`${ins_path}\`:\n"
ls -all "${ins_path}"
printf "\n"

#! /bin/bash

## date:    2021.05.31
## file:    compile and install tree
## author:  duruyao@hikvision.com
## release: http://mama.indstate.edu/users/ice/tree/src/

if [ $# != 2 ]; then
  printf "USAGE (sudo permission may be needed):\n"
  printf "    %s <ZIP_PATH> <INSTALL_PATH>\n" "${0}"
  exit 1
fi

zip_path="${1}"
ins_path="${2}"
new_folder="$(dirname "${zip_path}")/cmake_source"

mkdir -p "${new_folder}" && rm -rf "${new_folder:?}/"*
tar -zxvf "${zip_path}" -C "${new_folder}"

src_path="${new_folder}/$(ls "${new_folder}")"

mkdir -p "${ins_path}" && rm -rf "${ins_path:?}/"* && mkdir "${ins_path}"/man
cd "${src_path}" || exit

make -j16 && make prefix="${ins_path}" install

printf "\n"
printf "Install tree to \`${ins_path}\`:\n"
ls -all "${ins_path}"
printf "\n"

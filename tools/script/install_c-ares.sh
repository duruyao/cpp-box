#! /bin/bash

## date:    2021.05.17
## file:    compile and install c-ares
## author:  duruyao@hikvision.com
## release: https://github.com/c-ares/c-ares/releases

if [ $# != 2 ]; then
  printf "USAGE (sudo permission may be needed):\n"
  printf "    %s <ZIP_PATH> <INSTALL_PATH>\n" "${0}"
  exit 1
fi

zip_path="${1}"
ins_path="${2}"
new_folder="$(dirname "${zip_path}")/c-ares_source"

mkdir -p "${new_folder}" && rm -rf "${new_folder:?}/"*
unzip -q "${zip_path}" -d "${new_folder}"

src_path="${new_folder}/$(ls "${new_folder}")"

mkdir -p "${ins_path}" && rm -rf "${ins_path:?}/"*
cd "${src_path}" || exit
./buildconf
autoconf configure.ac
./configure --prefix="${ins_path}"
make -j16 && make install

printf "\n"
printf "Install c-ares to \`${ins_path}\`:\n"
ls -all "${ins_path}"
printf "\n"

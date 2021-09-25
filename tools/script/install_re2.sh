#! /bin/bash

## date:    2021.05.17
## file:    compile and install re2
## author:  duruyao@hikvision.com
## release: https://github.com/google/re2/releases

if [ $# != 2 ]; then
  printf "USAGE (sudo permission may be needed):\n"
  printf "    %s <ZIP_PATH> <INSTALL_PATH>\n" "${0}"
  exit 1
fi

zip_path="${1}"
ins_path="${2}"
new_folder="$(dirname "${zip_path}")/re2_source"

mkdir -p "${new_folder}" && rm -rf "${new_folder:?}/"*
unzip -q "${zip_path}" -d "${new_folder}"

src_path="${new_folder}/$(ls "${new_folder}")"

mkdir -p "${ins_path}" && rm -rf "${ins_path:?}"/*
cd "${src_path}" || exit

## modify `prefix="/usr/local"` in `Makefile`
#ins_path=${ins_path//\//\\\/}
#ins_path_old="/usr/local"
#ins_path_old=${ins_path_old//\//\\\/}
#sed -i "s/prefix=${ins_path_old}/prefix=${ins_path}/g" `grep "prefix=${ins_path_old}" -rl Makefile`
#make -j16 && make install

make -j16 && make prefix="${ins_path}" install

printf "\n"
printf "Install re2 to \`${ins_path}\`:\n"
ls -all "${ins_path}"
printf "\n"

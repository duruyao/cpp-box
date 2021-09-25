#! /bin/bash

## date:    2021.05.17
## file:    compile and install abseil-cpp
## author:  duruyao@hikvision.com
## release: https://github.com/abseil/abseil-cpp/releases

if [ ${#} != 2 ]; then
  printf "USAGE (sudo permission may be needed):\n"
  printf "    %s <ZIP_PATH> <INSTALL_PATH>\n" "${0}"
  exit 1
fi

zip_path="${1}"
ins_path="${2}"
new_folder="$(dirname "${zip_path}")/abseil-cpp_source"

mkdir -p "${new_folder}" && rm -rf "${new_folder:?}/"*
unzip -q "${zip_path}" -d "${new_folder}"

src_path="${new_folder}/$(ls "${new_folder}")"
build_path="${src_path}/build"

mkdir -p "${build_path}" && rm -rf "${build_path:?}/"*
mkdir -p "${ins_path}" && rm -rf "${ins_path:?}/"*

cd "${build_path}" || exit

## add rpath for the installed lib

cmake .. -DCMAKE_CXX_FLAGS="-std=c++11" \
  -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_SHARED_LIBS=ON \
  -DCMAKE_INSTALL_PREFIX="${ins_path}" \
  -DCMAKE_SKIP_BUILD_RPATH=OFF \
  -DCMAKE_BUILD_WITH_INSTALL_RPATH=OFF \
  -DCMAKE_INSTALL_RPATH="${ins_path}/lib" \
  -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=ON

make -j16 && make install

printf "\n"
printf "Install abseil-cpp to \`${ins_path}\`:\n"
ls -all "${ins_path}"
printf "\n"

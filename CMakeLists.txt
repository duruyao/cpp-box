## set minimum cmake version
cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

## project name and language
project(cpp-box LANGUAGES C CXX)

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_EXTENSIONS OFF)
set(CMAKE_C_STANDARD_REQUIRED ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

include(CheckFunctionExists)
include(CheckLibraryExists)
include(CheckIncludeFiles)
include(CheckIncludeFile)
include(CheckSymbolExists)
include(CheckStructHasMember)
include(CMakeDependentOption)
include(FindPkgConfig)

## append CMAKE_MODULE_PATH
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/tools/cmake)

find_package(PythonInterp 3 EXACT REQUIRED)
find_package(PythonLibs ${PYTHON_VERSION_MAJOR}.${PYTHON_VERSION_MINOR} EXACT)

include(CheckPyPackages)
check_py_packages(${PYTHON_EXECUTABLE}
        PACKAGES Conda Panda
        REQUIRED_PACKAGES Numpy)

include(AddProtocTarget)
add_protoc_target(proto2all protoc
        SOURCE_DIR ${CMAKE_SOURCE_DIR}/src/proto
        DESTINATION_DIR ${CMAKE_SOURCE_DIR}/src/proto
        OUTPUT_TYPES cpp go java python)

#add_subdirectory(src)

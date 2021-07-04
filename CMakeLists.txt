# set minimum cmake version
cmake_minimum_required(VERSION 3.0 FATAL_ERROR)

# project name and language
project(cxx-box LANGUAGES C CXX)

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_EXTENSIONS OFF)
set(CMAKE_C_STANDARD_REQUIRED ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

if(CMAKE_C_COMPILER_LOADED)
    message(STATUS "The C compiler ID: ${CMAKE_C_COMPILER_ID}")
    message(STATUS "The C compiler version: ${CMAKE_C_COMPILER_VERSION}")
    message(STATUS "The C compiler external toolchain: ${CMAKE_C_COMPILER_EXTERNAL_TOOLCHAIN}")
endif()

if(CMAKE_CXX_COMPILER_LOADED)
    message(STATUS "The CXX compiler ID: ${CMAKE_CXX_COMPILER_ID}")
    message(STATUS "The CXX compiler version: ${CMAKE_CXX_COMPILER_VERSION}")
    message(STATUS "The CXX compiler external toolchain: ${CMAKE_CXX_COMPILER_EXTERNAL_TOOLCHAIN}")
endif()

include(CheckFunctionExists)
include(CheckLibraryExists)
include(CheckIncludeFiles)
include(CheckIncludeFile)
include(CheckSymbolExists)
include(CheckStructHasMember)
include(CMakeDependentOption)
include(FindPkgConfig)

add_subdirectory(src)

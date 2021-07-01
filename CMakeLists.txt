cmake_minimum_required(VERSION 3.0 FATAL_ERROR)
project(cxx-box C CXX)
set(CMAKE_CXX_STANDARD 11)

include(CheckFunctionExists)
include(CheckLibraryExists)
include(CheckIncludeFiles)
include(CheckIncludeFile)
include(CheckSymbolExists)
include(CheckStructHasMember)
include(CMakeDependentOption)
include(FindPkgConfig)

add_subdirectory(src)

# set minimum cmake version
cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

set(name "")
if (NOT name)
    get_filename_component(name ${CMAKE_CURRENT_SOURCE_DIR} NAME)
    string(REPLACE " " "-" name ${name})
    string(REPLACE "_" "-" name ${name})
    string(REPLACE "--" "-" name ${name})
    string(TOLOWER "${name}" name)
endif ()

# project name and language
project(${name} LANGUAGES C CXX)

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_EXTENSIONS OFF)
set(CMAKE_C_STANDARD_REQUIRED ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

if (NOT DEFINED BUILD_ONLY_SHARED_LIBS)
    option(BUILD_ONLY_SHARED_LIBS "Build only shared libraries" OFF)
endif ()
if (NOT DEFINED BUILD_ONLY_STATIC_LIBS)
    option(BUILD_ONLY_STATIC_LIBS "Build only static libraries" OFF)
endif ()

aux_source_directory(${CMAKE_CURRENT_SOURCE_DIR} sources)
message(DEBUG "[DEBUG] sources: ${sources}")

if (NOT BUILD_ONLY_STATIC_LIBS)
    add_library(${name}-shared SHARED
            ${sources})
    target_include_directories(${name}-shared
            PRIVATE ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/include)
    set_target_properties(${name}-shared
            PROPERTIES OUTPUT_NAME ${name})
endif ()

if (NOT BUILD_ONLY_SHARED_LIBS)
    add_library(${name}-static STATIC
            ${sources})
    target_include_directories(${name}-static
            PRIVATE ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/include)
    set_target_properties(${name}-static
            PROPERTIES OUTPUT_NAME ${name})
endif ()

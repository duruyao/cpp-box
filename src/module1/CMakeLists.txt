# set minimum cmake version
cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

set(project "")
if (NOT project)
    get_filename_component(project ${CMAKE_CURRENT_SOURCE_DIR} NAME)
    string(REPLACE " " "-" project ${project})
    string(REPLACE "_" "-" project ${project})
    string(REPLACE "--" "-" project ${project})
    string(TOLOWER "${project}" project)
endif ()

# project name and language
project(${project}
        VERSION 1.0.0
        LANGUAGES C CXX)

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_EXTENSIONS OFF)
set(CMAKE_C_STANDARD_REQUIRED ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

option(BUILD_ONLY_SHARED_LIBS "Build only shared libraries" OFF)
option(BUILD_ONLY_STATIC_LIBS "Build only static libraries" OFF)
if (NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type" FORCE)
endif ()

aux_source_directory(${CMAKE_CURRENT_SOURCE_DIR} sources)
message(DEBUG "[DEBUG] ${project} sources: ${sources}")

if (NOT BUILD_ONLY_STATIC_LIBS)
    add_library(${project}-shared SHARED
            ${sources})
    target_include_directories(${project}-shared
            PUBLIC ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/include)
    set_target_properties(${project}-shared
            PROPERTIES OUTPUT_NAME ${project}
            SOVERSION ${PROJECT_VERSION_MAJOR}
            VERSION ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_PATCH})
endif ()

if (NOT BUILD_ONLY_SHARED_LIBS)
    add_library(${project}-static STATIC
            ${sources})
    target_include_directories(${project}-static
            PUBLIC ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/include)
    set_target_properties(${project}-static
            PROPERTIES OUTPUT_NAME ${project}
            SOVERSION ${PROJECT_VERSION_MAJOR}
            VERSION ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_PATCH})
endif ()

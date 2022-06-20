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

# general set up
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

# print debug messages of variables
#
# debug_vars([variable]...)
function(DEBUG_VARS)
    foreach (var IN ITEMS ${ARGV})
        message(DEBUG "[DEBUG] ${var}: ${${var}}")
    endforeach ()
endfunction()

# find sources and header files
aux_source_directory(${CMAKE_CURRENT_SOURCE_DIR} sources)
aux_source_directory(${CMAKE_CURRENT_SOURCE_DIR}/src sources)
debug_vars(sources)

set(PUBLIC_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/include CACHE PATH "Public include directories")
set(PRIVATE_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR} CACHE PATH "Private include directories")
debug_vars(PUBLIC_INCLUDE_DIR PRIVATE_INCLUDE_DIR)

file(GLOB public_headers ${PUBLIC_INCLUDE_DIR}/*.h ${PUBLIC_INCLUDE_DIR}/*.hpp)
debug_vars(public_headers)

# set up installing directories
include(GNUInstallDirs)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR})
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR})
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})

set(INSTALL_LIBDIR ${CMAKE_INSTALL_LIBDIR} CACHE PATH "Installation directory for libraries")
set(INSTALL_BINDIR ${CMAKE_INSTALL_BINDIR} CACHE PATH "Installation directory for executables")
set(INSTALL_INCLUDEDIR ${CMAKE_INSTALL_INCLUDEDIR} CACHE PATH "Installation directory for header files")
if (WIN32 AND NOT CYGWIN)
    set(INSTALL_CMAKEDIR CMake CACHE PATH "Installation directory for CMake files")
else ()
    set(INSTALL_CMAKEDIR share/cmake/${PROJECT_NAME} CACHE PATH "Installation directory for CMake files")
endif ()

foreach (item IN ITEMS LIB INCLUDE CMAKE)
    file(TO_NATIVE_PATH ${CMAKE_INSTALL_PREFIX}/${INSTALL_${item}DIR} path)
    message(STATUS "Installing ${project} ${item} components to ${path}")
    unset(path)
endforeach ()

# set up RPATH (Run-time Search Path)
file(RELATIVE_PATH relative_path ${CMAKE_INSTALL_PREFIX}/${INSTALL_BINDIR} ${CMAKE_INSTALL_PREFIX})
if (APPLE)
    set(rpath "@loader_path/${relative_path}")
else ()
    set(rpath "\$ORIGIN/${relative_path}")
endif ()
file(TO_NATIVE_PATH "${rpath}/${INSTALL_LIBDIR}" install_rpath)

# add target shared libraries
if (NOT BUILD_ONLY_STATIC_LIBS)
    add_library(${project}-shared SHARED)
    target_sources(${project}-shared
            PRIVATE ${sources})
    target_include_directories(${project}-shared
            PUBLIC ${PUBLIC_INCLUDE_DIR}
            PRIVATE ${PRIVATE_INCLUDE_DIR})
    set_target_properties(${project}-shared
            PROPERTIES
            OUTPUT_NAME ${project}
            PUBLIC_HEADER "${public_headers}"
            SOVERSION ${PROJECT_VERSION_MAJOR}
            VERSION ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_PATCH}
            POSITION_INDEPENDENT_CODE 1
            MACOSX_RPATH ON
            SKIP_BUILD_RPATH OFF
            BUILD_WITH_INSTALL_RPATH OFF
            INSTALL_RPATH "${install_rpath}"
            INSTALL_RPATH_USE_LINK_PATH ON
            WINDOWS_EXPORT_ALL_SYMBOLS ON)
    list(APPEND targets ${project}-shared)
endif ()

# add target static libraries
if (NOT BUILD_ONLY_SHARED_LIBS)
    add_library(${project}-static STATIC)
    target_sources(${project}-static
            PRIVATE ${sources})
    target_include_directories(${project}-static
            PUBLIC ${PUBLIC_INCLUDE_DIR}
            PRIVATE ${PRIVATE_INCLUDE_DIR})
    set_target_properties(${project}-static
            PROPERTIES
            OUTPUT_NAME ${project}
            PUBLIC_HEADER "${public_headers}"
            SOVERSION ${PROJECT_VERSION_MAJOR}
            VERSION ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_PATCH}
            POSITION_INDEPENDENT_CODE 1
            MACOSX_RPATH ON
            SKIP_BUILD_RPATH OFF
            BUILD_WITH_INSTALL_RPATH OFF
            INSTALL_RPATH "${install_rpath}"
            INSTALL_RPATH_USE_LINK_PATH ON
            WINDOWS_EXPORT_ALL_SYMBOLS ON)
    list(APPEND targets ${project}-static)
endif ()

# install bin, libs, header files
install(TARGETS ${targets}
        ARCHIVE
        DESTINATION ${INSTALL_LIBDIR}
        COMPONENT lib
        RUNTIME
        DESTINATION ${INSTALL_BINDIR}
        COMPONENT bin
        LIBRARY
        DESTINATION ${INSTALL_LIBDIR}
        COMPONENT lib
        PUBLIC_HEADER
        DESTINATION ${INSTALL_INCLUDEDIR}/${project}
        COMPONENT include)

## date:   2022-06-14
## author: duruyao@gmail.com
## desc:   find cjson

# find cjson
#
# find_package(cJSON [version] [EXACT] [QUIET] [MODULE]
#         [REQUIRED] [[COMPONENTS] [components...]]
#         [OPTIONAL_COMPONENTS components...]
#         [REGISTRY_VIEW <64|32|64_32|32_64|HOST|TARGET|BOTH> ]
#         [NO_POLICY_SCOPE]
#         [GLOBAL])
if (NOT cJSON_FOUND)
    find_path(cJSON_ROOT
            NAMES cJSON.h
            PATHS ${CMAKE_SOURCE_DIR}/third_party/cJSON
            REQUIRED
            NO_DEFAULT)
    find_path(cJSON_INCLUDE_DIRS
            NAMES cJSON.h
            PATHS ${cJSON_ROOT}
            REQUIRED
            NO_DEFAULT_PATH)
    find_file(cJSON_SOURCES
            NAMES cJSON.c
            PATHS ${cJSON_ROOT}
            REQUIRED
            NO_DEFAULT_PATH)

    include(FindPackageHandleStandardArgs)
    find_package_handle_standard_args(cJSON
            FOUND_VAR cJSON_FOUND
            REQUIRED_VARS cJSON_INCLUDE_DIRS cJSON_SOURCES)
endif ()

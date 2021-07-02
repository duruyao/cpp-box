
#include(${PROJECT_SOURCE_DIR}/src/cfg_mgr)
#include(${PROJECT_SOURCE_DIR}/src/log_mgr)

## use cjson
include(${PROJECT_SOURCE_DIR}/tools/cmake/use_cjson.cmake)

include_directories(${CMAKE_CURRENT_SOURCE_DIR})
include_directories(${PROJECT_SOURCE_DIR}/src/cfg_mgr)
include_directories(${PROJECT_SOURCE_DIR}/src/log_mgr)

aux_source_directory(${CMAKE_CURRENT_SOURCE_DIR} source_files)
aux_source_directory(${PROJECT_SOURCE_DIR}/src/cfg_mgr source_files)
aux_source_directory(${PROJECT_SOURCE_DIR}/src/log_mgr source_files)

get_filename_component(app_name ${CMAKE_CURRENT_SOURCE_DIR} NAME)
string(REPLACE " " "-" app_name ${app_name})
string(REPLACE "_" "-" app_name ${app_name})
string(REPLACE "--" "-" app_name ${app_name})

add_executable(${app_name} ${source_files})

target_link_libraries(${app_name} ${third_party_libs})

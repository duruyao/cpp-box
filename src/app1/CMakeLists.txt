
#include(${PROJECT_SOURCE_DIR}/src/module1)
#include(${PROJECT_SOURCE_DIR}/src/module2)

include_directories(${CMAKE_CURRENT_SOURCE_DIR})
include_directories(${PROJECT_SOURCE_DIR}/src/module1)
include_directories(${PROJECT_SOURCE_DIR}/src/module2)

aux_source_directory(${CMAKE_CURRENT_SOURCE_DIR} source_files)
aux_source_directory(${PROJECT_SOURCE_DIR}/src/module1 source_files)
aux_source_directory(${PROJECT_SOURCE_DIR}/src/module2 source_files)

get_filename_component(app_name ${CMAKE_CURRENT_SOURCE_DIR} NAME)
string(REPLACE " " "-" app_name ${app_name})
string(REPLACE "_" "-" app_name ${app_name})
string(REPLACE "--" "-" app_name ${app_name})

add_executable(${app_name} ${source_files})

target_link_libraries(${app_name} ${third_party_libs})

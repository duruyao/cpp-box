find_package(cJSON REQUIRED)
find_package(ZeroMQ REQUIRED)
find_package(CppZeroMQ REQUIRED)

get_filename_component(app ${CMAKE_CURRENT_SOURCE_DIR} NAME)
string(REPLACE " " "-" app ${app})
string(REPLACE "_" "-" app ${app})
string(REPLACE "--" "-" app ${app})

aux_source_directory(${cJSON_SOURCE_DIRS} sources)
aux_source_directory(${CMAKE_CURRENT_SOURCE_DIR} sources)
aux_source_directory(${PROJECT_SOURCE_DIR}/src/module1 sources)
aux_source_directory(${PROJECT_SOURCE_DIR}/src/module2 sources)

add_executable(${app} ${sources})

include_directories(
        ${cJSON_INCLUDE_DIRS}
        ${ZeroMQ_INCLUDE_DIRS}
        ${CppZeroMQ_INCLUDE_DIRS}
        ${CMAKE_CURRENT_SOURCE_DIR}
        ${PROJECT_SOURCE_DIR}/src/module1
        ${PROJECT_SOURCE_DIR}/src/module2)

target_link_libraries(${app} ${ZeroMQ_LIBRARIES})
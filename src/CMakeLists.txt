find_package(ProtoBuf REQUIRED)

## the following 3 lines are not required
#set(Proto_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/proto)
#set(Proto_DESTINATION_DIR ${CMAKE_CURRENT_SOURCE_DIR}/proto)
#set(Proto_TO_CC_TARGET "proto2cpp")
include(${PROJECT_SOURCE_DIR}/tools/cmake/ProtoToCc.cmake)

add_subdirectory(app1)
add_subdirectory(app2)
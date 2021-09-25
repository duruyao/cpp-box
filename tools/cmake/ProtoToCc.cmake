if (ProtoBuf_FOUND)
    if (NOT Proto_SOURCE_DIRS OR NOT EXISTS ${Proto_SOURCE_DIRS})
        file(MAKE_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/proto)
        set(Proto_SOURCE_DIRS ${CMAKE_CURRENT_SOURCE_DIR}/proto)
    endif ()

    if (NOT Proto_DESTINATION_DIRS OR NOT EXISTS ${Proto_DESTINATION_DIRS})
        file(MAKE_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/proto)
        set(Proto_DESTINATION_DIRS ${CMAKE_CURRENT_SOURCE_DIR}/proto)
    endif ()

    file(GLOB Proto_SOURCES CONFIGURE_DEPENDS ${Proto_SOURCE_DIRS}/*.proto)

    add_custom_command(OUTPUT Proto_TO_CC_CMD
            COMMAND ${ProtoBuf_EXECUTABLE} -I ${Proto_SOURCE_DIRS} --cpp_out=${Proto_DESTINATION_DIRS} ${Proto_SOURCES}
            DEPENDS ${Proto_SOURCES})

    if (NOT Proto_TO_CC_TARGET)
        set(Proto_TO_CC_TARGET "proto2cc")
    endif ()
    add_custom_target(${Proto_TO_CC_TARGET} DEPENDS Proto_TO_CC_CMD)
endif ()
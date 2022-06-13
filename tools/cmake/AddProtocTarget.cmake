## date:   2022-06-13
## author: duruyao@gmail.com
## desc:   add a target to compile protobuf sources to some specif language sources

# add_protoc_target(<name> <protobuf-executable>
#         [SOURCE_DIR <source-directory>]
#         [DESTINATION_DIR <destination-directory>]
#         [OUTPUT_TYPES {cpp|csharp|dart|go|java|kotlin|objc|php|pyi|python|ruby}...]
#         )
function(ADD_PROTOC_TARGET TARGET EXECUTABLE)
    set(prefix ARG)
    set(options)
    set(oneValueKeywords SOURCE_DIR DESTINATION_DIR)
    set(multiValueKeywords OUTPUT_TYPES)
    set(valid_output_types cpp csharp dart go java kotlin objc php pyi python ruby)

    cmake_parse_arguments(PARSE_ARGV 2 "${prefix}" "${options}" "${oneValueKeywords}" "${multiValueKeywords}")

    if (NOT EXISTS ${EXECUTABLE})
        message(FATAL_ERROR "No such file: ${EXECUTABLE}")
    endif ()
    if (NOT EXISTS ${${prefix}_SOURCE_DIR})
        message(FATAL_ERROR "No such directory: ${${prefix}_SOURCE_DIR}")
    endif ()
    file(MAKE_DIRECTORY ${${prefix}_DESTINATION_DIR})
    file(GLOB sources CONFIGURE_DEPENDS ${${prefix}_SOURCE_DIR}/*.proto)

    set(protoc_commands)
    foreach (type IN LISTS ${prefix}_OUTPUT_TYPES)
        if (NOT ${type} IN_LIST valid_output_types)
            message(FATAL_ERROR "Unknown output type: ${type}")
        endif ()

        add_custom_command(OUTPUT protoc_command_output_${type}
                COMMAND ${EXECUTABLE} --proto_path=${${prefix}_SOURCE_DIR} --${type}_out=${${prefix}_DESTINATION_DIR} ${proto_sources}
                DEPENDS ${sources})
        list(APPEND protoc_commands ${protoc_command_output_${type}})
    endforeach ()

    add_custom_target(${TARGET} DEPENDS ${protoc_commands})
endfunction()

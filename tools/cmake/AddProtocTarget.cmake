## date:   2022-06-13
## author: duruyao@gmail.com
## desc:   add a target to compile protobuf sources to some specific language sources

# add a target to compile protobuf sources to some specific language sources
#
# add_protoc_target(<target-name> <protobuf-executable>
#         SOURCE_DIR <source-directory>
#         DESTINATION_DIR <destination-directory>
#         OUTPUT_TYPES <cpp|csharp|dart|go|java|kotlin|objc|php|pyi|python|ruby>...)
function(ADD_PROTOC_TARGET TARGET EXECUTABLE)
    set(prefix ADD_PROTOC_TARGET)
    set(options)
    set(oneValueKeywords SOURCE_DIR DESTINATION_DIR)
    set(multiValueKeywords OUTPUT_TYPES)
    set(valid_output_types cpp csharp dart go java kotlin objc php pyi python ruby)

    cmake_parse_arguments(PARSE_ARGV 2 "${prefix}" "${options}"
            "${oneValueKeywords}" "${multiValueKeywords}")
    message(DEBUG "${prefix}_TARGET: ${TARGET}")
    message(DEBUG "${prefix}_EXECUTABLE: ${EXECUTABLE}")
    message(DEBUG "${prefix}_SOURCE_DIR: ${${prefix}_SOURCE_DIR}")
    message(DEBUG "${prefix}_DESTINATION_DIR: ${${prefix}_DESTINATION_DIR}")
    message(DEBUG "${prefix}_OUTPUT_TYPES: ${${prefix}_OUTPUT_TYPES}")

    if (${ARGC} LESS 8)
        message(FATAL_ERROR "add_protoc_target called with incorrect number of arguments")
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

        add_custom_command(OUTPUT from_proto_to_${type}
                COMMAND ${EXECUTABLE}
                ARGS --proto_path=${${prefix}_SOURCE_DIR} --${type}_out=${${prefix}_DESTINATION_DIR} ${sources}
                DEPENDS ${sources})
        message(DEBUG "from_proto_to_${type}: ${EXECUTABLE} --proto_path=${${prefix}_SOURCE_DIR} --${type}_out=${${prefix}_DESTINATION_DIR} ${sources}")

        list(APPEND protoc_commands from_proto_to_${type})
    endforeach ()

    message(DEBUG "protoc_commands: ${protoc_commands}")
    add_custom_target(${TARGET} ALL DEPENDS ${protoc_commands})
endfunction()

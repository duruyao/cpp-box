################################################################################
#       USING CJSON                                                            #
################################################################################

if (NOT DEFINED USE_CJSON_CMAKE)
    set(USE_CJSON_CMAKE)

    set(cjson_home ${PROJECT_SOURCE_DIR}/third_party/cjson)
    set(cjson_src_dir ${cjson_home}/src)
    set(cjson_include_dir ${cjson_home}/src)

    include_directories(SYSTEM ${cjson_include_dir})
    aux_source_directory(${cjson_src_dir} sources)
endif (NOT DEFINED USE_CJSON_CMAKE)

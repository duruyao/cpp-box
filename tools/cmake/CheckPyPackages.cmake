## date:   2022-06-09
## author: duruyao@gmail.com
## desc:   check python packages

# check python packages
#
# check_py_packages(<python-executable>
#         [PACKAGES <python-package>...]
#         [REQUIRED_PACKAGES <python-package>...]
#         )
function(CHECK_PY_PACKAGES EXECUTABLE)
    set(prefix CHECK_PY_PACKAGES)
    set(options)
    set(oneValueKeywords)
    set(multiValueKeywords PACKAGES REQUIRED_PACKAGES)

    cmake_parse_arguments(PARSE_ARGV 1 "${prefix}" "${options}" "${oneValueKeywords}" "${multiValueKeywords}")
    message(DEBUG "${prefix}_EXECUTABLE: ${EXECUTABLE}")
    message(DEBUG "${prefix}_PACKAGES: ${${prefix}_PACKAGES}")
    message(DEBUG "${prefix}_REQUIRED_PACKAGES: ${${prefix}_REQUIRED_PACKAGES}")

    if (${ARGC} LESS 1)
        message(FATAL_ERROR "check_py_packages called with incorrect number of arguments")
    endif ()

    foreach (PyPackage IN LISTS ${prefix}_PACKAGES ${prefix}_REQUIRED_PACKAGES)
        string(TOLOWER ${PyPackage} pypackage)

        if (NOT PythonPackage_${PyPackage}_FOUND)
            # find python package location
            execute_process(COMMAND
                    ${EXECUTABLE} "-c" "import re, ${pypackage}; print(re.compile('/__init__.py.*').sub('',${pypackage}.__file__))"
                    RESULT_VARIABLE status
                    OUTPUT_VARIABLE PythonPackage_${PyPackage}_LOCATION
                    ERROR_QUIET
                    OUTPUT_STRIP_TRAILING_WHITESPACE
                    )

            # find python package version
            execute_process(COMMAND
                    ${EXECUTABLE} "-c" "import ${pypackage}; print(${pypackage}.__version__)"
                    RESULT_VARIABLE status
                    OUTPUT_VARIABLE PythonPackage_${PyPackage}_VERSION
                    ERROR_QUIET
                    OUTPUT_STRIP_TRAILING_WHITESPACE
                    )

            include(FindPackageHandleStandardArgs)
            find_package_handle_standard_args(PythonPackage_${PyPackage}
                    FOUND_VAR PythonPackage_${PyPackage}_FOUND
                    REQUIRED_VARS PythonPackage_${PyPackage}_LOCATION
                    VERSION_VAR PythonPackage_${PyPackage}_VERSION
                    )

            if (NOT ${PythonPackage_${PyPackage}_FOUND} AND ${PyPackage} IN_LIST ${prefix}_REQUIRED_PACKAGES)
                message(FATAL_ERROR "The python package '${PyPackage}' required but not found")
            endif ()
        endif ()
    endforeach ()
endfunction()

## date:   2022-06-09
## author: duruyao@gmail.com
## desc:   check python environment (interpreter, libraries and packages)

#
# check_py_env(
#         [VERSION <python-version>]
#         [PACKAGES <python-package>...]
#         [INTERPRETER_REQUIRED]
#         [EXECUTABLE_REQUIRED]
#         [LIBS_REQUIRED]
#         [PACKAGES_REQUIRED]
# )
#
function(CHECK_PY_ENV)
    set(options INTERPRETER_REQUIRED EXECUTABLE_REQUIRED LIBS_REQUIRED PACKAGES_REQUIRED)
    set(oneValueKeywords VERSION)
    set(multiValueKeywords PACKAGES)

    cmake_parse_arguments(PARSE_ARGV 0 ARG "${options}" "${oneValueKeywords}" "${multiValueKeywords}")

    if ("${ARG_VERSION}" STREQUAL "")
        set(ARG_VERSION 2)
    endif ()

    set(PyInterpRequired)
    if (${ARG_INTERPRETER_REQUIRED} OR ${ARG_EXECUTABLE_REQUIRED})
        set(PyInterpRequired REQUIRED)
    endif ()

    set(PyLibsRequired)
    if (${ARG_LIBS_REQUIRED})
        set(PyLibsRequired REQUIRED)
    endif ()

    find_package(PythonInterp ${ARG_VERSION} EXACT ${PyInterpRequired})
    find_package(PythonInterp 2 EXACT ${PyInterpRequired})
    find_package(PythonInterp 3 EXACT ${PyInterpRequired})
    find_package(PythonLibs ${PYTHON_VERSION_MAJOR}.${PYTHON_VERSION_MINOR} EXACT ${PyLibsRequired})
    foreach (PyPackage IN ITEMS ${ARG_PACKAGES})
        string(TOLOWER ${PyPackage} pypackage)

        # find python package location
        execute_process(COMMAND
                ${PYTHON_EXECUTABLE} "-c" "import re, ${pypackage}; print(re.compile('/__init__.py.*').sub('',${pypackage}.__file__))"
                RESULT_VARIABLE status
                OUTPUT_VARIABLE PythonPackage_${PyPackage}_LOCATION
                ERROR_QUIET
                OUTPUT_STRIP_TRAILING_WHITESPACE
                )

        # find python package version
        execute_process(COMMAND
                ${PYTHON_EXECUTABLE} "-c" "import ${pypackage}; print(${pypackage}.__version__)"
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

        if (NOT ${PythonPackage_${PyPackage}_FOUND} AND ARG_PACKAGES_REQUIRED)
            message(FATAL_ERROR "PythonPackage_${PyPackage} required but not found")
        endif ()
    endforeach ()
endfunction()

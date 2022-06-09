## date:   2022-06-09
## author: duruyao@gmail.com
## desc:   check python environment (interpreter, libraries and packages)

include(FindPackageHandleStandardArgs)

find_package(PythonInterp REQUIRED)

find_package(PythonLibs ${PYTHON_VERSION_MAJOR}.${PYTHON_VERSION_MINOR} EXACT REQUIRED)

list(APPEND _PyPackageList NumPy Matplotlib)

foreach (_PyPackage IN ITEMS ${_PyPackageList})
    string(TOLOWER ${_PyPackage} _pypackage)

    # find python package location
    execute_process(COMMAND
            ${PYTHON_EXECUTABLE} "-c" "import re, ${_pypackage}; print(re.compile('/__init__.py.*').sub('',${_pypackage}.__file__))"
            RESULT_VARIABLE ${_pypackage}_status
            OUTPUT_VARIABLE ${_pypackage}_location
            ERROR_QUIET
            OUTPUT_STRIP_TRAILING_WHITESPACE
            )

    # find python package version
    execute_process(COMMAND
            ${PYTHON_EXECUTABLE} "-c" "import ${_pypackage}; print(${_pypackage}.__version__)"
            OUTPUT_VARIABLE ${_pypackage}_version
            ERROR_QUIET
            OUTPUT_STRIP_TRAILING_WHITESPACE
            )

    find_package_handle_standard_args(PythonPackage_${_PyPackage}
            FOUND_VAR PythonPackage_${_PyPackage}_FOUND
            REQUIRED_VARS ${_pypackage}_location
            VERSION_VAR ${_pypackage}_version
            )
endforeach ()

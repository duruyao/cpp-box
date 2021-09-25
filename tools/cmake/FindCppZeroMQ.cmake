if (NOT CppZeroMQ_FOUND)
    if (CppZeroMQ_HOME AND EXISTS ${CppZeroMQ_HOME})
        find_path(CppZeroMQ_INCLUDE_DIRS NAMES zmq.hpp PATHS ${CppZeroMQ_HOME}/include REQUIRED NO_DEFAULT_PATH)
    elseif (SDK_FOUND AND EXISTS ${SDK_HOME})
        find_path(CppZeroMQ_HOME NAMES include/zmq.hpp PATHS ${SDK_HOME}/cppzmq REQUIRED NO_DEFAULT_PATH)
        find_path(CppZeroMQ_INCLUDE_DIRS NAMES zmq.hpp PATHS ${CppZeroMQ_HOME}/include REQUIRED NO_DEFAULT_PATH)
    endif ()

    include(FindPackageHandleStandardArgs)
    find_package_handle_standard_args(CppZeroMQ FOUND_VAR CppZeroMQ_FOUND REQUIRED_VARS CppZeroMQ_HOME CppZeroMQ_INCLUDE_DIRS)
endif ()
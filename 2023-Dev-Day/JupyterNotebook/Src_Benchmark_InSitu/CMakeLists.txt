cmake_minimum_required(VERSION 3.16)

project(insitu_benchmark_suite)

if (NOT PYTHON_EXECUTABLE)
    message(FATAL_ERROR "Python executable cannot be found")
endif()
if (NOT PYTHON_INCLUDE_DIR)
    message(FATAL_ERROR "Python include directory cannot be found")
endif()
if (NOT PYTHON_LIBRARY)
    message(FATAL_ERROR "Python library cannot be found")
endif()

# Configure and load LLNL's BLT tool for
# extra CMake functionality
set(ENABLE_TESTS OFF CACHE BOOL "")
set(ENABLE_CLANGQUERY OFF CACHE BOOL "")
set(ENABLE_CLANGTIDY OFF CACHE BOOL "")
set(ENABLE_CPPCHECK OFF CACHE BOOL "")
set(ENABLE_ASTYLE OFF CACHE BOOL "")
set(ENABLE_CLANGFORMAT OFF CACHE BOOL "")
set(ENABLE_UNCRUSTIFY OFF CACHE BOOL "")
set(ENABLE_YAPF OFF CACHE BOOL "")
set(ENABLE_CMAKEFORMAT OFF CACHE BOOL "")
set(BLT_EXPORT_THIRDPARTY ON CACHE BOOL "")
include(subprojects/blt/SetupBLT.cmake)

# Add the 'cmake' directory to CMAKE_MODULE_PATH
# so that we can get 'Find' scripts
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

# Build shared libraries by default
set(BUILD_SHARED_LIBS ON CACHE BOOL "")

# Get install dir variables
include(GNUInstallDirs)

# Get ExternalProject
include(ExternalProject)

# Enable CMAKE_INSTALL_RPATH_USE_LINK_PATH to ensure RPATH is set
# correctly for built executables in the install directory
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)

if (NOT CMAKE_INSTALL_LIBDIR STREQUAL "lib")
    list(APPEND CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}")
endif()
list(APPEND CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib")

# Define baseline Boost components required by A4MD
set(boost_components
    "iostreams"
    "serialization"
)

find_package(Git REQUIRED)

# Check if we have support for C++'s std::filesystem
# If we do, set the compiler to C++17
# Otherwise, set the compiler to C++14 and require Boost.Filesystem
find_package(Filesystem COMPONENTS Final)
if (CXX_FILESYSTEM_HAVE_FS)
    message(STATUS "Compiler supports std::filesystem")
    set(CMAKE_CXX_STANDARD 17)
else()
    message(STATUS "Compiler doesn't support std::filesystem, so fall back to Boost.Filesystem")
    set(CMAKE_CXX_STANDARD 14)
    list(APPEND boost_components "filesystem")
endif()

# Find Boost with the iostreams, serialization,
# and (optionally) filesystem sublibraries
find_package(Boost
    1.60.0
    COMPONENTS ${boost_components}
    REQUIRED
)

# Find MPI
find_package(MPI REQUIRED)

# Add the subprojects directory to build the following:
#  * CLI11
#  * A4MD
add_subdirectory(subprojects)

# Define variables to be set by the DTL we are using
set(dtl_reader_class_name "")
set(dtl_writer_class_name "")

# Define the ENABLE_DTL configuration variable
# to select the DTL to use
set(ENABLE_DTL "" CACHE STRING "")

# Build the DTL
add_subdirectory(dtl)

# Build the benchmark executables
add_subdirectory(src)

# Install the Python scripts in `scripts` to libexec
install(
    DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/script/
    DESTINATION ${CMAKE_INSTALL_LIBEXECDIR}
    USE_SOURCE_PERMISSIONS
    FILES_MATCHING PATTERN "*.py"
)

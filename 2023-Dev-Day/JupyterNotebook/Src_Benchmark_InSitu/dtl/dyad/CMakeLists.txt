# Specify any CMake Cache variables
set(DYAD_GIT_TAG "ucx"
    CACHE STRING
    "The Git tag, branch name, etc. to use when checking out DYAD"
)
set(DYAD_API "wrapper"
    CACHE STRING
    "The type of DYAD API to use when building. Can be either 'wrapper' or 'stream'"
)

if (NOT ("${DYAD_API}" STREQUAL "wrapper") AND NOT ("${DYAD_API}" STREQUAL "stream"))
    message(FATAL_ERROR "DYAD_API has an invalid value ${DYAD_API}")
endif()


###########################################
# Put any type of dependency loading here #
###########################################

set(c_args "CC=${CMAKE_C_COMPILER} CFLAGS=${CMAKE_C_FLAGS}")
set(cxx_args "CXX=${CMAKE_CXX_COMPILER} CXX_FLAGS=${CMAKE_CXX_FLAGS}")

find_program(MAKE_EXECUTABLE NAMES make REQUIRED)

message(STATUS "DYAD_GIT_TAG is ${DYAD_GIT_TAG}")

ExternalProject_Add(
    dyad_import
    #GIT_REPOSITORY https://github.com/flux-framework/dyad.git
    GIT_REPOSITORY https://github.com/TauferLab/dyad.git
    # To prevent the update (i.e., clone) step from running everytime,
    # set GIT_TAG to an actual tag or a commit SHA
    GIT_TAG ${DYAD_GIT_TAG}
    SOURCE_DIR ${CMAKE_BINARY_DIR}/dyad
    INSTALL_DIR ${CMAKE_BINARY_DIR}/dyad/install
    CONFIGURE_COMMAND ./autogen.sh COMMAND ./configure --prefix=<INSTALL_DIR> --enable-dyad-debug
        CC=${CMAKE_C_COMPILER} CFLAGS=${CMAKE_C_FLAGS}
        CXX=${CMAKE_CXX_COMPILER} CXX_FLAGS=${CMAKE_CXX_FLAGS}
    BUILD_COMMAND ${MAKE_EXECUTABLE}
    INSTALL_COMMAND ${MAKE_EXECUTABLE} install
    BUILD_IN_SOURCE 1
)

install(
    DIRECTORY ${CMAKE_BINARY_DIR}/dyad/install/bin/
    DESTINATION ${CMAKE_INSTALL_BINDIR}
    USE_SOURCE_PERMISSIONS
)
install(
    DIRECTORY ${CMAKE_BINARY_DIR}/dyad/install/lib/
    DESTINATION ${CMAKE_INSTALL_LIBDIR}
    USE_SOURCE_PERMISSIONS
)
install(
    DIRECTORY ${CMAKE_BINARY_DIR}/dyad/install/include/
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
    USE_SOURCE_PERMISSIONS
)

# Configure the dtl_defines.hpp file
#
# This file contains any #define statements needed by the DTL.
# The only CMake variable that must be set before running configure_file
# is NEEDS_MPI.
set(NEEDS_MPI FALSE)
if ("${DYAD_API}" STREQUAL "stream")
    set(DYAD_API_STREAM TRUE)
    set(DYAD_API_WRAPPER FALSE)
elseif ("${DYAD_API}" STREQUAL "wrapper")
    set(DYAD_API_STREAM FALSE)
    set(DYAD_API_WRAPPER TRUE)
endif()
configure_file(dtl_defines.hpp.in ${dtl_post_inc_dir}/dtl_defines.hpp)

# Build your DTL sublibrary as a CMake Object Library.
#
# If you loaded any dependencies, add a DEPENDS_ON line to the
# blt_add_library command below. For more information, see:
# https://llnl-blt.readthedocs.io/en/develop/api/target.html#blt-add-library
blt_add_library(
    NAME dyad_dtl
    OBJECT TRUE
    SOURCES dyad_reader.cpp dyad_writer.cpp
    HEADERS dyad_reader.hpp dyad_writer.hpp ${dtl_post_inc_dir}/dtl_defines.hpp
    INCLUDES ${CMAKE_CURRENT_SOURCE_DIR} ${dtl_base_inc_dir} ${dtl_post_inc_dir}
    DEPENDS_ON a4md_cmn CLI11::CLI11
)

if ("${DYAD_API}" STREQUAL "stream")
    message(STATUS "Linking libdyad_stream.so into DYAD DTL")
    target_link_libraries(dyad_dtl PUBLIC ${CMAKE_BINARY_DIR}/dyad/install/lib/libdyad_fstream.so)
    target_include_directories(dyad_dtl PUBLIC ${CMAKE_BINARY_DIR}/dyad/install/include)
endif()

add_dependencies(dyad_dtl dyad_import)

if (CXX_FILESYSTEM_HAVE_FS)
    target_link_libraries(
        dyad_dtl
        PUBLIC
        std::filesystem
    )
elseif (Boost_FILESYSTEM_FOUND)
    blt_patch_target(
        NAME dyad_dtl
        LIBRARIES ${Boost_LIBRARIES}
        INCLUDES ${Boost_INCLUDE_DIRS}
    )
else()
    message(
        FATAL_ERROR
        "Cannot find Boost.Filesystem or std::filesystem (required by dyad DTL)"
    )
endif()

# Add compilation features by uncommenting and editting the line below
# target_compile_features(test PUBLIC|PRIVATE ...)

# Only change these lines if you change the names of the
# header files
set(reader_header "dyad_reader.hpp")
set(writer_header "dyad_writer.hpp")
# Only change these lines if you change the names of the
# reader or writer classes
set(reader_class "DyadReader")
set(writer_class "DyadWriter")

#############################################
# DO NOT CHANGE ANYTHING BELOW THIS COMMENT #
#############################################
set(dtl_target dyad_dtl PARENT_SCOPE)
set(dtl_writer_header ${writer_header} PARENT_SCOPE)
set(dtl_reader_header ${reader_header} PARENT_SCOPE)
set(dtl_internal_reader_class_name ${reader_class} PARENT_SCOPE)
set(dtl_internal_writer_class_name ${writer_class} PARENT_SCOPE)

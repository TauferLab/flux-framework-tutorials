###########################################
# Put any type of dependency loading here #
###########################################

# Specify any CMake Cache variables


# Build your DTL sublibrary as a CMake Object Library.
#
# If you loaded any dependencies, add a DEPENDS_ON line to the
# blt_add_library command below. For more information, see:
# https://llnl-blt.readthedocs.io/en/develop/api/target.html#blt-add-library
blt_add_library(
    NAME dspaces_dtl
    OBJECT TRUE
    SOURCES dspaces_reader.cpp dspaces_writer.cpp
    HEADERS dspaces_reader.hpp dspaces_writer.hpp
    INCLUDES $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}> $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}> ${dtl_base_inc_dir}
    DEPENDS_ON a4md_cmn CLI11::CLI11 a4md_dtl mpi
)

# Add compilation features by uncommenting and editting the line below
# target_compile_features(test PUBLIC|PRIVATE ...)

# Only change these lines if you change the names of the
# header files
set(reader_header "dspaces_reader.hpp")
set(writer_header "dspaces_writer.hpp")
# Only change these lines if you change the names of the
# reader or writer classes
set(reader_class "DSpacesReader")
set(writer_class "DSpacesWriter")

#############################################
# DO NOT CHANGE ANYTHING BELOW THIS COMMENT #
#############################################
set(dtl_target dspaces_dtl PARENT_SCOPE)
set_property(GLOBAL PROPERTY NEEDS_MPI TRUE)
set_property(GLOBAL PROPERTY DTL_READER_HEADER ${reader_header})
set_property(GLOBAL PROPERTY DTL_WRITER_HEADER ${writer_header})
set_property(GLOBAL PROPERTY DTL_READER_CLASS ${reader_class})
set_property(GLOBAL PROPERTY DTL_WRITER_CLASS ${writer_class})

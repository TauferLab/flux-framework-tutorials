###########################################
# Put any type of dependency loading here #
###########################################

# Specify any CMake Cache variables
{{ cmake_option_commands }}

# Build your DTL sublibrary as a CMake Object Library.
#
# If you loaded any dependencies, add a DEPENDS_ON line to the
# blt_add_library command below. For more information, see:
# https://llnl-blt.readthedocs.io/en/develop/api/target.html#blt-add-library
blt_add_library(
    NAME {{ cmake_target }}
    OBJECT TRUE
    SOURCES {{ file_prefix }}_reader.cpp {{ file_prefix }}_writer.cpp
    HEADERS {{ file_prefix }}_reader.hpp {{ file_prefix }}_writer.hpp
    INCLUDES $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}> $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}> ${dtl_base_inc_dir}
    DEPENDS_ON a4md_cmn CLI11::CLI11 {% if needs_mpi == "TRUE" %}mpi{% endif %}
)

# Add compilation features by uncommenting and editting the line below
# target_compile_features(test PUBLIC|PRIVATE ...)

# Only change these lines if you change the names of the
# header files
set(reader_header "{{ file_prefix }}_reader.hpp")
set(writer_header "{{ file_prefix }}_writer.hpp")
# Only change these lines if you change the names of the
# reader or writer classes
set(reader_class "{{ class_prefix }}Reader")
set(writer_class "{{ class_prefix }}Writer")

#############################################
# DO NOT CHANGE ANYTHING BELOW THIS COMMENT #
#############################################
set(dtl_target {{ cmake_target }} PARENT_SCOPE)
set_property(GLOBAL PROPERTY NEEDS_MPI {{ needs_mpi }})
set_property(GLOBAL PROPERTY DTL_READER_HEADER ${reader_header})
set_property(GLOBAL PROPERTY DTL_WRITER_HEADER ${writer_header})
set_property(GLOBAL PROPERTY DTL_READER_CLASS ${reader_class})
set_property(GLOBAL PROPERTY DTL_WRITER_CLASS ${writer_class})

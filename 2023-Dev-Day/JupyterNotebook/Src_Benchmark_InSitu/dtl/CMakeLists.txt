set(dtl_base_inc_dir ${CMAKE_CURRENT_SOURCE_DIR}/benchmark_dtl)

if (ENABLE_DTL STREQUAL "")
    message(FATAL_ERROR "A value must be provided to ENABLE_DTL")
endif()

set(dtl_post_inc_dir ${CMAKE_CURRENT_BINARY_DIR}/dtl)

set(dtl_reader_header "")
set(dtl_writer_header "")
set(dtl_internal_reader_class_name "")
set(dtl_internal_writer_class_name "")

set(dtl_target "")
add_subdirectory(${ENABLE_DTL})

if (dtl_target STREQUAL "")
    message(FATAL_ERROR "The 'dtl_target' variable is empty")
endif()
if (dtl_reader_header STREQUAL "")
    message(FATAL_ERROR "The DTL did not record the name of its reader header")
endif()
if (dtl_writer_header STREQUAL "")
    message(FATAL_ERROR "The DTL did not record the name of its writer header")
endif()
if (dtl_internal_reader_class_name STREQUAL "")
    message(FATAL_ERROR "The DTL did not record the name of its reader class")
endif()
if (dtl_internal_writer_class_name STREQUAL "")
    message(FATAL_ERROR "The DTL did not record the name of its writer class")
endif()

set(dtl_reader_class_name "${dtl_internal_reader_class_name}" PARENT_SCOPE)
set(dtl_writer_class_name "${dtl_internal_writer_class_name}" PARENT_SCOPE)

add_subdirectory("dtl_headers")

set(source_files
    "${dtl_base_inc_dir}/benchmark_reader.cpp"
    "${dtl_base_inc_dir}/benchmark_writer.cpp"
)
set(header_files
    "${dtl_base_inc_dir}/benchmark_reader.hpp"
    "${dtl_base_inc_dir}/benchmark_writer.hpp"
)

blt_add_library(
    NAME benchmark_dtl
    SOURCES ${source_files}
    HEADERS ${header_files}
    INCLUDES ${dtl_base_inc_dir} ${dtl_post_inc_dir}
    DEPENDS_ON ${dtl_target}
)

install(
    TARGETS benchmark_dtl
    EXPORT InSituBenchmarkExport
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
    PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)

# Build balanced_producer
configure_file(
    "balanced_producer.cpp"
    "${CMAKE_CURRENT_BINARY_DIR}/balanced_producer.cpp"
    @ONLY
)
blt_add_executable(
    NAME balanced_producer
    SOURCES "${CMAKE_CURRENT_BINARY_DIR}/balanced_producer.cpp"
    INCLUDES ${PYTHON_INCLUDE_DIR}
    DEPENDS_ON benchmark_dtl a4md_ingest MPI::MPI_C
    ${exec_defines}
)

install(
    TARGETS balanced_producer
    EXPORT InSituBenchmarkExport
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

# Build balanced_consumer
configure_file(
    "balanced_consumer.cpp"
    "${CMAKE_CURRENT_BINARY_DIR}/balanced_consumer.cpp"
    @ONLY
)
blt_add_executable(
    NAME balanced_consumer
    SOURCES "${CMAKE_CURRENT_BINARY_DIR}/balanced_consumer.cpp"
    INCLUDES ${PYTHON_INCLUDE_DIR}
    DEPENDS_ON benchmark_dtl a4md_retrieve MPI::MPI_C
    ${exec_defines}
)
set_target_properties(balanced_consumer PROPERTIES ENABLE_EXPORTS ON)

install(
    TARGETS balanced_consumer
    EXPORT InSituBenchmarkExport
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

blt_add_executable(
    NAME calc_chunk_size
    SOURCES calc_chunk_size.cpp
    DEPENDS_ON CLI11::CLI11
)
install(
    TARGETS calc_chunk_size
    EXPORT InSituBenchmarkExport
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

blt_add_executable(
    NAME calc_natoms
    SOURCES calc_natoms.cpp
    DEPENDS_ON CLI11::CLI11
)
install(
    TARGETS calc_natoms
    EXPORT InSituBenchmarkExport
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

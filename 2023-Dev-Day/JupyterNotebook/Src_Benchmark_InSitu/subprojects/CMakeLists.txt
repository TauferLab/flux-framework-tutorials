set(dtl_dspaces ON CACHE BOOL "")
set(dtl_dimes OFF CACHE BOOL "")
set(dtl_decaf OFF CACHE BOOL "")
set(build_examples OFF CACHE BOOL "")
set(build_tests OFF CACHE BOOL "")
set(build_wrap OFF CACHE BOOL "")

add_subdirectory(a4md)

add_subdirectory(CLI11)

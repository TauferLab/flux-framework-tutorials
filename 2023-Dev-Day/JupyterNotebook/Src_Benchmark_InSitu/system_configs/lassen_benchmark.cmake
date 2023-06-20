########################################
# Set built-in configuration variables #
########################################
set(ENABLE_DTL "dyad" CACHE STRING "")
set(CMAKE_BUILD_TYPE "Release" CACHE STRING "")
set(CMAKE_C_COMPILER "/usr/tce/packages/gcc/gcc-8.3.1/bin/gcc" CACHE STRING "")
set(CMAKE_CXX_COMPILER "/usr/tce/packages/gcc/gcc-8.3.1/bin/g++" CACHE STRING "")
set(CMAKE_Fortran_COMPILER "/usr/tce/packages/gcc/gcc-8.3.1/bin/gfortran" CACHE STRING "")
set(CMAKE_INSTALL_PREFIX "/usr/WS2/lumsden1/insitu_benchmark/Src_Benchmark_InSitu/_lassen_install" CACHE STRING "")
set(MPI_C_COMPILER "/usr/tce/packages/spectrum-mpi/spectrum-mpi-rolling-release-gcc-8.3.1/bin/mpicc" CACHE STRING "")
set(MPI_CXX_COMPILER "/usr/tce/packages/spectrum-mpi/spectrum-mpi-rolling-release-gcc-8.3.1/bin/mpicxx" CACHE STRING "")
set(MPI_Fortran_COMPILER "/usr/tce/packages/spectrum-mpi/spectrum-mpi-rolling-release-gcc-8.3.1/bin/mpif90" CACHE STRING "")

###############################################
# Set variables to search for Python in CMake #
###############################################
set(PYTHON_EXECUTABLE "/usr/tce/packages/python/python-3.8.2/bin/python3.8" CACHE PATH "")
set(PYTHON_INCLUDE_DIR "/usr/tce/packages/python/python-3.8.2/include/python3.8/" CACHE PATH "")
set(PYTHON_LIBRARY "/usr/tce/packages/python/python-3.8.2/lib/libpython3.8.so.1.0" CACHE PATH "")

################################################
# Sets variables to configure DTL integrations #
################################################

# Variables for dspaces

# Variables for dyad
set(DYAD_GIT_TAG "ucx" CACHE STRING "The Git tag, branch name, etc. to use when checking out DYAD")
set(DYAD_API "stream" CACHE STRING "The type of DYAD API to use when building. Can be either 'wrapper' or 'stream'")

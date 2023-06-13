########################################
# Set built-in configuration variables #
########################################
set(ENABLE_DTL "dyad" CACHE STRING "")
set(CMAKE_BUILD_TYPE "Release" CACHE STRING "")
set(CMAKE_C_COMPILER "/usr/bin/gcc" CACHE STRING "")
set(CMAKE_CXX_COMPILER "/usr/bin/g++" CACHE STRING "")
set(CMAKE_Fortran_COMPILER "/usr/bin/gfortran" CACHE STRING "")
set(CMAKE_INSTALL_PREFIX "/usr" CACHE STRING "")
set(MPI_C_COMPILER "/usr/bin/mpicc" CACHE STRING "")
set(MPI_CXX_COMPILER "/usr/bin/mpicxx" CACHE STRING "")
set(MPI_Fortran_COMPILER "/usr/bin/mpif90" CACHE STRING "")

###############################################
# Set variables to search for Python in CMake #
###############################################
set(PYTHON_EXECUTABLE "/usr/bin/python3" CACHE PATH "")
set(PYTHON_INCLUDE_DIR "/usr/include/python3.8/" CACHE PATH "")
set(PYTHON_LIBRARY "/usr/lib/x86_64-linux-gnu/libpython3.8.so.1.0" CACHE PATH "")

################################################
# Sets variables to configure DTL integrations #
################################################

# Variables for dspaces

# Variables for dyad
set(DYAD_GIT_TAG "ucx" CACHE STRING "The Git tag, branch name, etc. to use when checking out DYAD")
set(DYAD_API "wrapper" CACHE STRING "The type of DYAD API to use when building. Can be either 'wrapper' or 'stream'")

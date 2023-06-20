########################################
# Set built-in configuration variables #
########################################
set(ENABLE_DTL "dyad" CACHE STRING "")
set(CMAKE_BUILD_TYPE "Debug" CACHE STRING "")
set(CMAKE_C_COMPILER "/usr/tce/packages/gcc/gcc-8.1.0/bin/gcc" CACHE STRING "")
set(CMAKE_CXX_COMPILER "/usr/tce/packages/gcc/gcc-8.1.0/bin/g++" CACHE STRING "")
set(CMAKE_Fortran_COMPILER "/usr/tce/packages/gcc/gcc-8.1.0/bin/gfortran" CACHE STRING "")
set(CMAKE_INSTALL_PREFIX "/usr/WS2/lumsden1/insitu_benchmark/Src_Benchmark_InSitu/_catalyst_install" CACHE STRING "")
set(MPI_C_COMPILER "/usr/tce/packages/mvapich2/mvapich2-2.3-gcc-8.1.0/bin/mpicc" CACHE STRING "")
set(MPI_CXX_COMPILER "/usr/tce/packages/mvapich2/mvapich2-2.3-gcc-8.1.0/bin/mpicxx" CACHE STRING "")
set(MPI_Fortran_COMPILER "/usr/tce/packages/mvapich2/mvapich2-2.3-gcc-8.1.0/bin/mpif90" CACHE STRING "")

###############################################
# Set variables to search for Python in CMake #
###############################################
set(PYTHON_EXECUTABLE "/collab/usr/gapps/python/build/spack-toss3.4/opt/spack/linux-rhel7-ivybridge/gcc-4.9.3/python-3.8.2-6me27g5yfvrxpcsemax25kovzjbf22vt/bin/python3.8" CACHE PATH "")
set(PYTHON_INCLUDE_DIR "/collab/usr/gapps/python/build/spack-toss3.4/opt/spack/linux-rhel7-ivybridge/gcc-4.9.3/python-3.8.2-6me27g5yfvrxpcsemax25kovzjbf22vt/include/python3.8" CACHE PATH "")
set(PYTHON_LIBRARY "/collab/usr/gapps/python/build/spack-toss3.4/opt/spack/linux-rhel7-ivybridge/gcc-4.9.3/python-3.8.2-6me27g5yfvrxpcsemax25kovzjbf22vt/lib/libpython3.8.so.1.0" CACHE PATH "")

################################################
# Sets variables to configure DTL integrations #
################################################

# Variables for dspaces

# Variables for dyad
#set(DYAD_GIT_TAG "ucx" CACHE STRING "The Git tag, branch name, etc. to use when checking out DYAD")
set(DYAD_GIT_TAG "ucx" CACHE STRING "The Git tag, branch name, etc. to use when checking out DYAD")


########################################
# Set built-in configuration variables #
########################################
set(ENABLE_DTL "dyad" CACHE STRING "")
set(CMAKE_BUILD_TYPE "Release" CACHE STRING "")
set(CMAKE_C_COMPILER "/usr/tce/packages/gcc/gcc-10.3.1-magic/bin/gcc" CACHE STRING "")
set(CMAKE_CXX_COMPILER "/usr/tce/packages/gcc/gcc-10.3.1-magic/bin/g++" CACHE STRING "")
set(CMAKE_Fortran_COMPILER "/usr/tce/packages/gcc/gcc-10.3.1-magic/bin/gfortran" CACHE STRING "")
set(CMAKE_INSTALL_PREFIX "/usr/WS2/lumsden1/insitu_benchmark/Src_Benchmark_InSitu/_corona_install" CACHE STRING "")
set(MPI_C_COMPILER "/usr/tce/packages/mvapich2/mvapich2-2.3.6-gcc-10.3.1-magic/bin/mpicc" CACHE STRING "")
set(MPI_CXX_COMPILER "/usr/tce/packages/mvapich2/mvapich2-2.3.6-gcc-10.3.1-magic/bin/mpicxx" CACHE STRING "")
set(MPI_Fortran_COMPILER "/usr/tce/packages/mvapich2/mvapich2-2.3.6-gcc-10.3.1-magic/bin/mpifort" CACHE STRING "")

###############################################
# Set variables to search for Python in CMake #
###############################################
set(PYTHON_EXECUTABLE "/collab/usr/gapps/python/build/spack-toss4.1/var/spack/environments/python/._view/75prb56irmif5ejtirjthpx6kq3gqo52/bin/python3.9" CACHE PATH "")
set(PYTHON_INCLUDE_DIR "/collab/usr/gapps/python/build/spack-toss4.1/opt/spack/linux-rhel8-ivybridge/gcc-10.3.1/python-3.9.12-qeu37vouuau7gmcuom6z7lxzrfmktk3h/include/python3.9" CACHE PATH "")
set(PYTHON_LIBRARY "/collab/usr/gapps/python/build/spack-toss4.1/opt/spack/linux-rhel8-ivybridge/gcc-10.3.1/python-3.9.12-qeu37vouuau7gmcuom6z7lxzrfmktk3h/lib/libpython3.9.so.1.0" CACHE PATH "")

################################################
# Sets variables to configure DTL integrations #
################################################

# Variables for dspaces

# Variables for dyad
set(DYAD_GIT_TAG "ucx" CACHE STRING The Git tag, branch name, etc. to use when checking out DYAD)


########################################
# Set built-in configuration variables #
########################################
set(ENABLE_DTL "dyad" CACHE STRING "")
set(CMAKE_BUILD_TYPE "Release" CACHE STRING "")
set(CMAKE_C_COMPILER "/usr/tce/packages/gcc/gcc-12.1.1-magic/bin/gcc" CACHE STRING "")
set(CMAKE_CXX_COMPILER "/usr/tce/packages/gcc/gcc-12.1.1-magic/bin/g++" CACHE STRING "")
set(CMAKE_Fortran_COMPILER "/usr/tce/packages/gcc/gcc-12.1.1-magic/bin/gfortran" CACHE STRING "")
set(CMAKE_INSTALL_PREFIX "/usr/WS2/lumsden1/insitu_benchmark/Src_Benchmark_InSitu/_tioga_install" CACHE STRING "")
set(MPI_C_COMPILER "/opt/cray/pe/mpich/8.1.25/ofi/crayclang/10.0/bin/mpicc" CACHE STRING "")
set(MPI_CXX_COMPILER "/opt/cray/pe/mpich/8.1.25/ofi/crayclang/10.0/bin/mpicxx" CACHE STRING "")
set(MPI_Fortran_COMPILER "/opt/cray/pe/mpich/8.1.25/ofi/crayclang/10.0/bin/mpif90" CACHE STRING "")

###############################################
# Set variables to search for Python in CMake #
###############################################
set(PYTHON_EXECUTABLE "/collab/usr/gapps/python/build/spack-toss4.2/var/spack/environments/python310/._view/i74j3perqsso644fvgbrjnzhyuvpn42l/bin/python3.10" CACHE PATH "")
set(PYTHON_INCLUDE_DIR "/collab/usr/gapps/python/build/spack-toss4.2/opt/spack/linux-rhel8-ivybridge/gcc-10.3.1/python-3.10.8-eo2xpt7z2jslmvhvc6hzxr2sbhsrcwi5/include/python3.10" CACHE PATH "")
set(PYTHON_LIBRARY "/collab/usr/gapps/python/build/spack-toss4.2/opt/spack/linux-rhel8-ivybridge/gcc-10.3.1/python-3.10.8-eo2xpt7z2jslmvhvc6hzxr2sbhsrcwi5/lib/libpython3.10.so.1.0" CACHE PATH "")

################################################
# Sets variables to configure DTL integrations #
################################################

# Variables for dspaces

# Variables for dyad
set(DYAD_GIT_TAG "ucx" CACHE STRING The Git tag, branch name, etc. to use when checking out DYAD)
set(DYAD_API "wrapper" CACHE STRING The type of DYAD API to use when building. Can be either 'wrapper' or 'stream')


#!/bin/sh

# This script builds underworld2 on the rhel6 operating system at fram.
# To select the required branch to build, just specify the branch name:
#   $./caltech_fram.sh development
# Defaults to master branch

# Tested successfully 8/9/2016

# ensure we bail on errors
set -e

# load numpy modules, which will also load other required modules.
module load numpy/1.8.2-intel-2016a-Python-2.7.11

export I_MPI_CC=icc  # select icc

# install a more recent version of swig
wget http://prdownloads.sourceforge.net/swig/swig-3.0.10.tar.gz
tar zxf swig-3.0.10.tar.gz
cd swig-3.0.10
./configure --prefix=$HOME/swig
make
make install
cd

# install petsc and hdf5
wget http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-3.6.4.tar.gz
tar zxf petsc-3.6.4.tar.gz
cd petsc-3.6.4
./configure --download-mpi4py=1 --with-debugging=0 --prefix=$HOME/petsc/rhel6 --download-hdf5=1 --download-hdf5-shared=1 --download-f2cblaslapack=1 --with-fc=0
make PETSC_DIR=$HOME/petsc-3.6.4 PETSC_ARCH=arch-linux2-c-opt all
make PETSC_DIR=$HOME/petsc-3.6.4 PETSC_ARCH=arch-linux2-c-opt install
cd

export HDF5_DIR=$HOME/petsc/rhel6
export PETSC_DIR=$HOME/petsc/rhel6

export PYTHONPATH=$HOME/petsc/rhel6/lib:$PYTHONPATH            # for mpi4py
export PATH=$HOME/petsc/rhel6/bin/:$HOME/swig/bin:$PATH        # for h5pcc and swig
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/petsc/rhel6/lib  # required by h5py

# underworld
git clone https://github.com/underworldcode/underworld2.git
cd underworld2/libUnderworld
git checkout $1
./configure.py --with-debugging=0 --numpy-dir=$EBROOTNUMPY/lib/python2.7/site-packages/numpy/core --python-dir=$EBROOTPYTHON
./compile.py

# some messages
echo "#############################################"
echo "Underworld2 built successfully.              "
echo "Remember to set the required environment     "
echo "variables before running Underworld2.        "
echo "For bash:"
echo "   export PYTHONPATH=$HOME/petsc/rhel6/lib:$HOME/underworld2:\$PYTHONPATH"
echo "   export LD_LIBRARY_PATH=$HOME/petsc/rhel6/lib:\$LD_LIBRARY_PATH "
echo ""
echo "You will also want to load the numpy module: "
echo "   module load numpy/1.8.2-intel-2016a-Python-2.7.11"
echo "#############################################"

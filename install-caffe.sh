#!/bin/bash

# install caffe's dependencies
sudo apt-get update
sudo apt-get -y install libprotobuf-dev libleveldb-dev libsnappy-dev libopencv-dev libhdf5-serial-dev protobuf-compiler
sudo apt-get -y install --no-install-recommends libboost-all-dev
sudo apt-get -y install libatlas-base-dev
sudo apt-get -y install libgflags-dev libgoogle-glog-dev liblmdb-dev

# download caffe and edit makefile
cd ~/
git clone https://github.com/BVLC/caffe
cd ~/caffe
# copy & edit Makefile to use CPU only and build with python layers
cp Makefile.config.example Makefile.config
sed -i 's/# CPU_ONLY := 1/CPU_ONLY := 1/g' Makefile.config
sed -i 's/# WITH_PYTHON_LAYER := 1/WITH_PYTHON_LAYER := 1/g' Makefile.config

# make it!
make -j$(nproc)
make -j$(nproc) test
make runtest

# download python requirements
cd ~/caffe/python
for req in $(cat requirements.txt); do sudo pip install "$req"; done
cd ~/caffe
make -j$(nproc) pycaffe

# for the ipython notebooks
sudo pip install jupyter
# pytest
sudo pip install pytest pytest-sugar
# upgrade numpy
sudo pip install --upgrade numpy

#!/bin/bash

echo -e "\n Setting up environment in Ubuntu 14.04"
sudo apt-get -y update
sudo apt-get -y install \
 build-essential \
 git \
 cmake \
 unzip \
 device-tree-compiler \
 libncurses-dev \
 cu \
 linux-image-extra-virtual \
 u-boot-tools \
 python-dev \
 python-pip

if uname -a |grep -q 64;
then
  echo -e "\n Installing 32bit compatibility libraries"
  sudo apt-get install libc6-i386 lib32stdc++6 lib32z1
fi

#echo -e "\n Adding current user to dialout group"
#sudo add ${USER} dialout

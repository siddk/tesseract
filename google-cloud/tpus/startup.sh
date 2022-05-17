#!/bin/bash

## Basic Python & XLA Setup

# Make `python` point to `python3`
sudo apt install -y python-is-python3
sudo apt-mark hold python2 python2-minimal python2.7 python2.7-minimal libpython2-stdlib libpython2.7-minimal libpython2.7-stdlib

# Ensure Torch-XLA is *always* set...
echo 'export XRT_TPU_CONFIG="localservice;0;localhost:51011"' >> ~/.bashrc
echo 'export PATH="${PATH}:${HOME}/.local/bin"' >> ~/.bashrc
source ~/.bashrc

## Install NFS
sudo apt-get -y update
sudo apt-get -y install nfs-common

# Create NFS Mount Point & Mount [SWAP w/ ACTUAL NFS SERVER INTERNAL IP]
sudo mkdir -p /mnt/home
sudo mount 10.0.0.2:/vol1 /mnt/home
sudo chmod go+rw /mnt/home

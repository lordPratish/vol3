#!/bin/bash

# Check for root privileges
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Update package lists
apt-get update

# Install pip
if ! command -v pip3 &> /dev/null; then
    wget https://bootstrap.pypa.io/pip/get-pip.py
    python3 get-pip.py || { echo "Could not install pip"; exit 1; }
fi

# Upgrade setuptools
pip3 install --upgrade setuptools

# Install dependencies for pycryptodome and volatility3
apt-get install -y python3-dev

# Install pycryptodome, distorm3, and yara-python
pip3 install pycryptodome distorm3 yara-python

# Clone volatility3 repository
if ! command -v git &> /dev/null; then
    echo "Git not found. Please install Git and try again"
    exit 1
fi
if [ ! -d "volatility3" ]; then
    git clone https://github.com/volatilityfoundation/volatility3.git
fi
cd volatility3 || { echo "Could not change to volatility3 directory"; exit 1; }

# Install minimal requirements for volatility3
pip3 install -r requirements-minimal.txt

# Display volatility3 help
if [ -d "volatility3" ]; then
    python3 vol.py -h
else
    echo "Could not find volatility3 directory. Please check if the directory was created correctly"
    exit 1
fi

#!/bin/bash

# Update package lists
sudo apt-get update

# Install pip
wget https://bootstrap.pypa.io/pip/get-pip.py
sudo python3 get-pip.py

# Upgrade setuptools
pip3 install --upgrade setuptools

# Install dependencies for pycryptodome and volatility3
sudo apt-get install python3-dev

# Install pycryptodome
pip3 install pycryptodome

# Install distorm3
pip3 install distorm3 

# Install yara-python
pip3 install yara-python

# Clone volatility3 repository
git clone https://github.com/volatilityfoundation/volatility3.git
cd volatility3

# Install minimal requirements for volatility3
pip3 install -r requirements-minimal.txt

# Display volatility3 help
python3 vol.py -h

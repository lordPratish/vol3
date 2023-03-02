#!/bin/bash

# Define color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Check for root privileges
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}This script must be run as root${NC}" 
   exit 1
fi

# Update package lists
if apt-get update; then
    echo -e "${GREEN}Package lists updated successfully${NC}"
else
    echo -e "${RED}Could not update package lists${NC}"
    exit 1
fi

# Install pip
if ! command -v pip3 &> /dev/null; then
    if wget https://bootstrap.pypa.io/pip/get-pip.py && python3 get-pip.py; then
        echo -e "${GREEN}Pip installed successfully${NC}"
    else
        echo -e "${RED}Could not install pip${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}Pip is already installed${NC}"
fi

# Upgrade setuptools
if pip3 install --upgrade setuptools; then
    echo -e "${GREEN}Setuptools upgraded successfully${NC}"
else
    echo -e "${RED}Could not upgrade setuptools${NC}"
    exit 1
fi

# Install dependencies for pycryptodome and volatility3
if apt-get install -y python3-dev; then
    echo -e "${GREEN}Dependencies for pycryptodome and volatility3 installed successfully${NC}"
else
    echo -e "${RED}Could not install dependencies for pycryptodome and volatility3${NC}"
    exit 1
fi

# Install pycryptodome, distorm3, and yara-python
if pip3 install pycryptodome distorm3 yara-python; then
    echo -e "${GREEN}pycryptodome, distorm3, and yara-python installed successfully${NC}"
else
    echo -e "${RED}Could not install pycryptodome, distorm3, and yara-python${NC}"
    exit 1
fi

# Clone volatility3 repository
if ! command -v git &> /dev/null; then
    echo -e "${RED}Git not found. Please install Git and try again${NC}"
    exit 1
fi
if [ ! -d "/opt/volatility3" ]; then
    if git clone https://github.com/volatilityfoundation/volatility3.git /opt/volatility3; then
        echo -e "${GREEN}Volatility3 repository cloned successfully${NC}"
    else
        echo -e "${RED}Could not clone Volatility3 repository${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}Volatility3 repository is already cloned${NC}"
fi
cd /opt/volatility3 || { echo -e "${RED}Could not change to volatility3 directory${NC}"; exit 1; }

# Install minimal requirements for volatility3
if pip3 install -r requirements-minimal.txt; then
    echo -e "${GREEN}Minimal requirements for volatility3 installed successfully${NC}"
else
    echo -e "${RED}Could not install minimal requirements for volatility3${NC}"
    exit 1
fi

# Download and extract Windows symbols
if [ ! -d "/opt/volatility3/volatility3/symbols" ]; then
    mkdir /opt/volatility3/volatility3/symbols
fi
cd /opt/volatility3/volatility3/symbols || { echo "Could not change to symbols directory"; exit 1; }
if ! wget -q https://downloads.volatilityfoundation.org/volatility3/symbols/windows.zip; then
    echo "Could not download symbols zip"
    exit 1
fi
if ! unzip -q windows.zip; then
    echo "Could not extract symbols zip"
    exit 1
fi

# Display volatility3 help
cd /opt/volatility3 || { echo "Could not change to volatility3 directory"; exit 1; }
if [ -d "volatility3" ]; then
    python3 volatility3/vol.py -h
else
    echo "Could not find volatility3 directory. Please check if the directory was created correctly"
    exit 1
fi

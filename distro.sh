#!/bin/bash
ARCH=$([ "$(uname -m)" == "x86_64" ] && echo "amd64" || echo "arm64")

if [ "${ARCH}" == "amd64" ];
then
bash <(curl -s https://raw.githubusercontent.com/RinoOnTop/Vps-EGG/main/RiNo-Vps.sh)
else 
echo 'arm64 is not supported yet'
fi

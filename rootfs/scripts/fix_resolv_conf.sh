#!/bin/bash

set -eo pipefail

if [[ "$(id -u)" -ne "0" ]]; then
    echo "This script requires root."
    exit 1
fi

# Overwrite resolv.conf
rm -rf /etc/resolv.conf
cat > /etc/resolv.conf <<EOF
nameserver 127.0.0.53
EOF
#search lan
#nameserver 8.8.8.8

echo "I: show /etc/resolv.conf"
cat /etc/resolv.conf

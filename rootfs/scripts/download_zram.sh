#!/bin/bash

echo "Create /var/lib/packages..."
mkdir -p /var/lib/packages

echo "Download systemd-zram-generator..."
cd /var/lib/packages
apt-get download systemd-zram-generator

#!/bin/bash

echo =========== Removing SSHD Keys ===============

set -eo pipefail

ls -l /etc/ssh/*key*

rm -f /etc/ssh/*key*

echo == keys removed


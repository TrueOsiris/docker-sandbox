#!/bin/bash
# /scripts/entrypoint.sh
# Author: Tim Chaubet

echo "========================================"
echo "Initializing Sandbox Container..."
if [ -f /etc/image_build_date ]; then
    cat /etc/image_build_date
else
    echo "Image build date not found."
fi
echo "========================================"

# Update the root password
echo "[INFO] Setting root password..."
echo "root:${SSH_PASSWORD}" | chpasswd

echo "[INFO] Starting OpenSSH server..."
service ssh start || /usr/sbin/sshd -D

echo "[INFO] System is ready."
# Keep the container alive
tail -f /dev/null
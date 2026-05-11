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

# Determine password: Use environment variable if present, otherwise fallback to 123456789
FINAL_PASSWORD="${SSH_PASSWORD:-123456789}"

# Update the root password
echo "[INFO] Setting root password..."
echo "root:${FINAL_PASSWORD}" | chpasswd

echo "[INFO] Starting OpenSSH server..."
service ssh start || /usr/sbin/sshd -D

echo "[INFO] System is ready."
# Keep the container alive
tail -f /dev/null
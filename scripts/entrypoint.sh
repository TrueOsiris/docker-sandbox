#!/bin/bash
# /scripts/entrypoint.sh
# Author: Tim Chaubet

# Update the root password using the environment variable passed from docker-compose
echo "root:${SSH_PASSWORD}" | chpasswd

# Start the SSH service
service ssh start || /usr/sbin/sshd

# Keep the container alive
while true; do sleep 1000; done
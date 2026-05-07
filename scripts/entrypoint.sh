#!/bin/bash
# /scripts/entrypoint.sh
# Author: Tim Chaubet

# Start the SSH service
service ssh start || /usr/sbin/sshd

# Keep the container alive
while true; do sleep 1000; done
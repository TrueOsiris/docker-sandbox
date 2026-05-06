#!/bin/bash
# /scripts/entrypoint.sh
# Author: Tim Chaubet

# Start the SSH service
service ssh start

# Keep the container alive
tail -f /dev/null
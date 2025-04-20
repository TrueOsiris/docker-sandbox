#!/bin/bash

# Ensure SSH_PASSWORD is set (default to '1234567890' if not provided)
SSH_PASSWORD="${SSH_PASSWORD:-1234567890}"

# Create the cron log file if it doesn't exist
/usr/bin/touch /var/log/cron.log 2>/dev/null
/usr/bin/chmod 666 /var/log/cron.log 2>/dev/null

basevol="/mnt/repos"
CF=$basevol/.credentials.txt

# Check if the credentials file exists, if not, create it
if [ ! -f "$CF" ]; then
    echo "$CF does not exist. Trying to create it."
    touch "$CF"
    echo "GITUSER=" > "$CF"
    echo "GITMAIL=" >> "$CF"
    echo "GITREPOUSER=" >> "$CF"
    echo 'GITROOT="git@github.com"' >> "$CF"
    echo "DOCKERUSER=" >> "$CF"
    echo "DOCKERPASS=" >> "$CF"
    echo "SSHPASS=" >> "$CF"
    echo "GITTOKEN=" >> "$CF"
    echo "AWSKEY=" >> "$CF"
    echo "AWSSECRET=" >> "$CF"
    echo "AWSREGION=" >> "$CF"
fi

# Source the credentials
source "$CF"

# Set environment variables
export GITUSER=${GITUSER:-""}
export GITMAIL=${GITMAIL:-""}
export DOCKERUSER=${DOCKERUSER:-""}
export DOCKERPASS=${DOCKERPASS:-""}
export SSHPASS=${SSHPASS:-""}
export GITREPOUSER=${GITREPOUSER:-$GITUSER}
export GITROOT=${GITROOT:-"git@github.com"}
export GITTOKEN=${GITTOKEN:-""}

# Configure git user and email
if [ -n "$GITUSER" ]; then
    /usr/bin/git config --system user.name "$GITUSER"
fi

if [ -n "$GITMAIL" ]; then
    /usr/bin/git config --system user.email "$GITMAIL"
fi

# Ensure Docker credentials are set (even though the logic for Docker auth is not explicitly shown in the original)
if [ -n "$DOCKERUSER" ] && [ -n "$DOCKERPASS" ]; then
    echo "$DOCKERUSER:$DOCKERPASS" | /usr/bin/docker login --username "$DOCKERUSER" --password-stdin
fi

# Ensure GitHub token is set for API use
if [ -n "$GITTOKEN" ]; then
    echo "GitHub Token is set."
fi

# Link the push scripts
/usr/bin/ln -s /scripts/gitpush.sh /usr/bin/gitpush
/usr/bin/ln -s /scripts/dockerpush.sh /usr/bin/dockerpush

# Set up SSH keys for GitHub
/usr/bin/mkdir -p $basevol/.ssh
echo 'n' | /usr/bin/ssh-keygen -t ed25519 -C "$GITMAIL" -P "" -f $basevol/.ssh/id_ed25519
echo ' '
/usr/bin/cat $basevol/.ssh/id_ed25519.pub
echo ' '
ssh -oStrictHostKeyChecking=no -T $GITROOT 2>/dev/null 1>/dev/null

# Configure git to use SSH instead of HTTPS
/usr/bin/git config --global url.ssh://$GITROOT/.insteadOf https://github.com/

# Setup cron log rotation
echo '/var/log/cron.log {
  rotate 7
  daily
  missingok
  notifempty
  create
}' > /etc/logrotate.d/git-cron

echo "30 5 * * * /usr/sbin/logrotate /etc/logrotate.d/git-cron" >> /etc/cron.d/git-cron

# Set root password and allow SSH login
echo "root:$SSH_PASSWORD" | chpasswd

# Update passwd file to use /mnt/repos as root's home directory
/usr/bin/sed '/root/s!\(.*:\).*:\(.*\)!\1/mnt/repos:\2!' /etc/passwd > /etc/passwd2
/usr/bin/mv /etc/passwd2 /etc/passwd

# Enable SSH root login and start SSH service
/usr/bin/sed -i 's/#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
/etc/init.d/ssh start

# Start cron daemon
/usr/bin/crontab /etc/cron.d/git-cron
/usr/sbin/cron -f

# Keep container running
/usr/bin/tail -f /var/log/cron.log

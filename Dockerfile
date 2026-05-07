# /Dockerfile
# Author: Tim Chaubet

FROM ubuntu:24.04

# Copy the scripts to the container
COPY scripts/ /scripts/
RUN chmod -R 755 /scripts

# Update, Upgrade, and Install core utilities + Docker CLI
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    vim \
    apt-utils \
    nmap \
    iputils-ping \
    net-tools \
    snmp \
    curl \
    gnupg \
    lsb-release \
    cron \
    logrotate \
    apt-transport-https \
    ca-certificates \
    software-properties-common \
    openssh-server \
    git \
    docker.io && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Configure OpenSSH
RUN mkdir /var/run/sshd && \
    echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config && \
    echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config

EXPOSE 22

CMD ["/scripts/entrypoint.sh"]
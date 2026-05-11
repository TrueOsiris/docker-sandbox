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
    subversion \
    docker.io && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Configure OpenSSH via a drop-in file to guarantee it overrides defaults
RUN mkdir -p /var/run/sshd && \
    echo 'PermitRootLogin yes' > /etc/ssh/sshd_config.d/99-custom.conf && \
    echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config.d/99-custom.conf

# Record the build time directly into the image
RUN echo "Image built on: $(date)" > /etc/image_build_date

EXPOSE 22

CMD ["/scripts/entrypoint.sh"]
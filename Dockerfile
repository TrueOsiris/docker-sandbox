FROM ubuntu:24.04

# Install dependencies and Docker
RUN apt-get update && \
 DEBIAN_FRONTEND=noninteractive apt-get install -y \
  apt-utils \
  python3 \
  python3-pip \
  python3-full \
  nmap \
  iputils-ping \
  net-tools \
  curl \
  gnupg \
  lsb-release \
  cron \
  logrotate \
  apt-transport-https \
  ca-certificates \
  software-properties-common \
  openssh-server && \
 apt-get clean && \
 apt-get autoremove -y && \
 apt-get autoclean -y && \
 rm -rf /var/lib/apt/lists/

# Install Docker (without Docker CE)
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/docker.gpg && \
 echo "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
  | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
 apt-get update && \
 apt-get install -y docker.io && \
 apt-get clean && \
 apt-get autoremove -y && \
 apt-get autoclean -y && \
 rm -rf /var/lib/apt/lists/

# Configure OpenSSH (set up password authentication for SSH)
RUN mkdir /var/run/sshd && \
 echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config && \
 echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config

# Copy all scripts to /scripts and make them executable
COPY scripts/ /scripts/
RUN chmod +x /scripts/*

# Set the root password using the SSH_PASSWORD environment variable
# Default to '123456789' if not provided
ARG SSH_PASSWORD=123456789
RUN echo "root:$SSH_PASSWORD" | chpasswd

# Expose the SSH port (22) for SSH access
EXPOSE 22

# Create volume for repos
VOLUME ["/mnt/repos"]

# Set the working directory
WORKDIR /mnt/repos

# Default command to run the start.sh script and SSH service
CMD ["/scripts/start.sh"]

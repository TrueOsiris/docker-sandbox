FROM ubuntu:24.04

COPY scripts/ /scripts/

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
  openssh-server \
  git && \
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
 echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config && \
 echo 'export LS_COLORS="rs=0:di=01;38;5;81:ln=01;36:mh=00:pi=40;33"' >> /root/.bashrc && \
 chmod +x /scripts/* && \
 echo "root:$SSH_PASSWORD" | chpasswd

# Expose the SSH port (22) for SSH access
EXPOSE 22

# Create volume for repos
VOLUME ["/mnt/repos"]

# Set the working directory
WORKDIR /mnt/repos

# Default command to run the start.sh script and SSH service
CMD ["/scripts/start.sh"]

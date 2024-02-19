FROM ubuntu:24.04

MAINTAINER Tim Chaubet <tim@chaubet.be>

RUN apt-get update && \
 DEBIAN_FRONTEND=noninteractive apt-get install -y \
  python3 \
  python3-pip \
  nmap \
  iputils-ping \
  net-tools \
  curl \
  gnupg \
  lsb-release \
 && \
 pip install --upgrade pip && \
 curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
 echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null && \
 apt-get update && \
 apt-get install docker-ce-cli && \
 apt-get clean && \
 apt-get autoremove -y && \
 apt-get autoclean -y && \
 rm -rf /var/lib/apt/lists/

    

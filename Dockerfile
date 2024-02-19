FROM ubuntu:24.04

MAINTAINER Tim Chaubet <tim@chaubet.be>

RUN apt-get update && \
 DEBIAN_FRONTEND=noninteractive apt-get install -y \
  apt-utils
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
 && \
 curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/docker.gpg && \
 echo \
  "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/ubuntu mantic stable" \ 
  | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
 apt-get update && \
 apt-get install -y \
  docker-ce-cli && \
 apt-get clean && \
 apt-get autoremove -y && \
 apt-get autoclean -y && \
 rm -rf /var/lib/apt/lists/
COPY start.sh /start.sh
RUN chmod +x /start.sh
CMD ["/start.sh"]    

#$(lsb_release -cs) stable"

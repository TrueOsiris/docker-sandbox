# /Dockerfile
# Author: Tim Chaubet

FROM ubuntu:24.04

COPY scripts/ /scripts/
RUN chmod -R 755 /scripts

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
    docker.io \
    python3 \
    python3-pip \
    python3-venv && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/share/vim/vimfiles/colors && \
    curl -fLo /usr/share/vim/vimfiles/colors/gruvbox.vim https://raw.githubusercontent.com/morhetz/gruvbox/master/colors/gruvbox.vim && \
    echo "syntax on" >> /etc/vim/vimrc.local && \
    echo "set termguicolors" >> /etc/vim/vimrc.local && \
    echo "set background=dark" >> /etc/vim/vimrc.local && \
    echo "colorscheme gruvbox" >> /etc/vim/vimrc.local

RUN mkdir -p /var/run/sshd && \
    echo 'PermitRootLogin yes' > /etc/ssh/sshd_config.d/99-custom.conf && \
    echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config.d/99-custom.conf

RUN echo "Image built on: $(date)" > /etc/image_build_date

EXPOSE 22

CMD ["/scripts/entrypoint.sh"]
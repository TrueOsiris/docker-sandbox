# docker-sandbox

``` yaml
  sandbox:
    image: trueosiris/sandbox:latest
    labels:
      net.unraid.docker.icon: "https://timmer.ninja/images/ico/sandbox.png"
    env_file:
      - ./sandbox/.env          
    environment:
      - PUID=0
      - PGID=0
      - TZ=Europe/Brussels
      - SSH_PASSWORD=${SSH_PASSWORD:-123456789}  # Default to '123456789' if not set in .env
    volumes:
      - type: bind
        source: /mnt/user/docker_volumes/dev/sandbox/repos 
        target: /mnt/repos 
        bind:
          create_host_path: true
    restart: unless-stopped
    networks:
      - dockerbridge
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "1"
    expose:
      - "22"
    ports:
      - 7322:22  
```
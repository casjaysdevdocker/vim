# vim Readme 👋

Vim is a highly configurable text editor

## Run container

dockermgr install vim

### via command line

```shell
docker run -d \
--restart always \
--name vim \
--hostname casjaysdev-vim \
-e TZ=${TIMEZONE:-America/New_York} \
-v $PWD/vim/data:/root \
-v $PWD/vim/config:/etc/vim \
casjaysdev/vim:latest
```

### via docker-compose

```yaml
version: "2"
services:
  vim:
    image: casjaysdev/vim
    container_name: vim
    environment:
      - TZ=America/New_York
      - HOSTNAME=casjaysdev-vim
    volumes:
      - $HOME/.local/share/docker/storage/vim/data:/root
      - $HOME/.local/share/docker/storage/vim/config:/etc/vim
    restart: 
      - always
```

## Authors  

🤖 Casjay: [Github](https://github.com/casjay) [Docker](https://hub.docker.com/casjay) 🤖  
⛵ CasjaysDev: [Github](https://github.com/casjaysdev) [Docker](https://hub.docker.com/casjaysdev) ⛵  

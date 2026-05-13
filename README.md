## 👋 Welcome to vim 🚀  

vim README  
  
  
## Install my system scripts  

```shell
 sudo bash -c "$(curl -q -LSsf "https://github.com/systemmgr/installer/raw/main/install.sh")"
 sudo systemmgr --config && sudo systemmgr install scripts  
```
  
## Automatic install/update  
  
```shell
dockermgr update vim
```
  
## Install and run container
  
```shell
dockerHome="/var/lib/srv/$USER/docker/casjaysdevdocker/vim/vim/latest/rootfs"
mkdir -p "/var/lib/srv/$USER/docker/vim/rootfs"
git clone "https://github.com/dockermgr/vim" "$HOME/.local/share/CasjaysDev/dockermgr/vim"
cp -Rfva "$HOME/.local/share/CasjaysDev/dockermgr/vim/rootfs/." "$dockerHome/"
docker run -d \
--restart always \
--privileged \
--name casjaysdevdocker-vim-latest \
--hostname vim \
-e TZ=${TIMEZONE:-America/New_York} \
-v "$dockerHome/data:/data:z" \
-v "$dockerHome/config:/config:z" \
-p 80:80 \
casjaysdevdocker/vim:latest
```
  
## via docker-compose  
  
```yaml
version: "2"
services:
  ProjectName:
    image: casjaysdevdocker/vim
    container_name: casjaysdevdocker-vim
    environment:
      - TZ=America/New_York
      - HOSTNAME=vim
    volumes:
      - "/var/lib/srv/$USER/docker/casjaysdevdocker/vim/vim/latest/rootfs/data:/data:z"
      - "/var/lib/srv/$USER/docker/casjaysdevdocker/vim/vim/latest/rootfs/config:/config:z"
    ports:
      - 80:80
    restart: always
```
  
## Get source files  
  
```shell
dockermgr download src casjaysdevdocker/vim
```
  
OR
  
```shell
git clone "https://github.com/casjaysdevdocker/vim" "$HOME/Projects/github/casjaysdevdocker/vim"
```
  
## Build container  
  
```shell
cd "$HOME/Projects/github/casjaysdevdocker/vim"
buildx 
```
  
## Authors  
  
🤖 casjay: [Github](https://github.com/casjay) 🤖  
⛵ casjaysdevdocker: [Github](https://github.com/casjaysdevdocker) [Docker](https://hub.docker.com/u/casjaysdevdocker) ⛵  

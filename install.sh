#!/bin/bash

source <(curl -s https://raw.githubusercontent.com/R1M-NODES/utils/master/common.sh)

printLogo

git clone

printGreen "Install docker and docker compose"
bash <(curl -s https://raw.githubusercontent.com/R1M-NODES/utils/master/docker-install.sh) && sleep 1


printGreen "Start Nginx"
cd $HOME || return
docker run --name snapshots --restart always -v $(pwd)/default.conf:/etc/nginx/conf.d/default.conf \
-v $(pwd)/snapshots/:/root/ -p 80:80 -d nginx

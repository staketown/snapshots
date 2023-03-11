#!/bin/bash

source <(curl -s https://raw.githubusercontent.com/R1M-NODES/utils/master/common.sh)

printLogo

git clone https://github.com/R1M-NODES/snapshots.git && cd cosmos-snapshots || exit 0
mkdir $HOME/snapshots/

printGreen "Install docker and docker compose"
bash <(curl -s https://raw.githubusercontent.com/R1M-NODES/utils/master/docker-install.sh) && sleep 1


printGreen "Start Nginx"
PORT=80
cd $HOME || return
docker run --name snapshots --restart always -v $(pwd)/default.conf:/etc/nginx/conf.d/default.conf \
-v $(pwd)/snapshots/:/root/ -p $PORT:80 -d nginx

printGreen "Nginx has beet started on port :$PORT"

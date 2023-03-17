#!/bin/bash

source <(curl -s https://raw.githubusercontent.com/R1M-NODES/utils/master/common.sh)

printLogo

git clone https://github.com/R1M-NODES/cosmos-snapshots.git && cd $HOME/cosmos-snapshots || exit 0
mkdir $HOME/snapshots/

printGreen "Install docker and docker compose"
bash <(curl -s https://raw.githubusercontent.com/R1M-NODES/utils/master/docker-install.sh) && sleep 1

printGreen "Start Nginx"

read -r -p "Enter port for nginx to expose (default 80): " PORT
PORT=${PORT:-80}
docker run --name snapshots --restart always -v $HOME/cosmos-snapshots/default.conf:/etc/nginx/conf.d/default.conf \
-v $HOME/snapshots/:/root/ -p $PORT:80 -d nginx

printGreen "Nginx has beet started on port :$PORT"

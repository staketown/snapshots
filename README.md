## Run your own backup server with snapshots  
Install requirements  
```bash
sudo apt update && \
sudo apt install curl git docker.io -y
```

Clone github repo  
`git clone https://github.com/c29r3/cosmos-snapshots.git && cd cosmos-snapshots`  

Create folder for snapshots  
`mkdir $HOME/snapshots/`

Start Nginx via docker  
```bash
cd $HOME; \
docker run --name snapshots \
--restart always \
-v $(pwd)/default.conf:/etc/nginx/conf.d/default.conf \
-v $(pwd)/snapshots/:/root/ \
-p 80:80 \
-d nginx
```

Fill in the variables in the file `akash_snapshot.sh`  
```
CHAIN_ID="akashnet-2"
SNAP_PATH="$HOME/snapshots/akash"
LOG_PATH="$HOME/snapshots/akash_log.txt"
DATA_PATH="$HOME/.akash/data/"
SERVICE_NAME="akash.service"
```
Create new snapshot  
`./akash_snapshot.sh`  

Check snapshot  
```bash
curl -s http://$(wget -qO- eth0.me)
```

## Automation  
You can add script to the cron  
```cron
# start every day at 00:00
0 0 * * * /bin/bash -c '/root/akash_snapshot.sh'
```

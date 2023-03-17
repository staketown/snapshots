#!/bin/bash

CHAIN_ID="gitopia-janus-testnet-2"
SNAP_PATH="$HOME/snapshots/gitopia"
LOG_PATH="$SNAP_PATH/gitopia_log.txt"
DATA_PATH="$HOME/.gitopia/data/"
CONFIG_PATH="$HOME/.gitopia/config/"
SERVICE_NAME="gitopiad"
RPC_ADDRESS="http://localhost:22657"
SNAP_NAME=$(echo "${CHAIN_ID}_$(date '+%Y-%m-%d').tar")
OLD_SNAP=$(ls ${SNAP_PATH} | egrep -o "${CHAIN_ID}.*tar")


now_date() {
    echo -n $(TZ=":Europe/Kyiv" date '+%Y-%m-%d_%H:%M:%S')
}

log_this() {
    YEL='\033[1;33m' # yellow
    NC='\033[0m'     # No Color
    local logging="$@"
    printf "|$(now_date)| $logging\n" | tee -a ${LOG_PATH}
}

mkdir -p $SNAP_PATH && chmod 777 -R $SNAP_PATH
LAST_BLOCK_HEIGHT=$(curl -s ${RPC_ADDRESS}/status | jq -r .result.sync_info.latest_block_height)
log_this "LAST_BLOCK_HEIGHT ${LAST_BLOCK_HEIGHT}"

log_this "Stopping ${SERVICE_NAME}"
sudo systemctl stop ${SERVICE_NAME}; echo $? >> ${LOG_PATH}

###################
log_this "Creating new snapshot"
time tar cf ${HOME}/${SNAP_NAME} -C ${DATA_PATH} . &>>${LOG_PATH}
cp $CONFIG_PATH/addrbook.json $SNAP_PATH/addrbook.json.new

###################
log_this "Starting ${SERVICE_NAME}"
sudo systemctl start ${SERVICE_NAME}; echo $? >> ${LOG_PATH}

##################
log_this "Removing old snapshot(s):"
cd ${SNAP_PATH}
rm -fv ${OLD_SNAP} &>>${LOG_PATH}
rm -fv addrbook.json &>>${LOG_PATH}

log_this "Moving new snapshot to ${SNAP_PATH}"
mv ${HOME}/${CHAIN_ID}*tar ${SNAP_PATH} &>>${LOG_PATH}
mv addrbook.json.new addrbook.json &>>${LOG_PATH}

#######################
log_this "Creating file info.json"

FILE_SIZE=$(du -hs ${SNAP_PATH} | awk '{print $1}')
log_this "File has size: ${FILE_SIZE}"

sudo tee $SNAP_PATH/info.json > /dev/null << EOF
{
  "blockHeight": "$LAST_BLOCK_HEIGHT",
  "fileName": "$SNAP_NAME",
  "fileSize": "$FILE_SIZE"
}
EOF

log_this "Done\n---------------------------\n"
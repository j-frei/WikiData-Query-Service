#!/usr/bin/env bash

old_cwd=$(pwd)
cd $(dirname "$0")
source utils.sh

# Data loading with loadData.sh
if [ ! -f ./data/.loadingData ]; then
    echo "Run data loading with loadData.sh..."
    mkdir -p ./logs
    ./service/loadData.sh -n wdq -h http://query-service:9999 -d $(pwd)/data/preprocessed > ./logs/log_loadData 2>&1
    checkSuccess $?
    touch ./data/.loadingData
else
    echo "Data loading with loadData.sh already performed."
fi

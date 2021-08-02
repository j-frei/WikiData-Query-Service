#!/usr/bin/env bash

old_cwd=$(pwd)
cd $(dirname "$0")
source utils.sh

# Preprocessing with munge.sh
if [ ! -d ./data/preprocessed ]; then
    mkdir -p ./data/preprocessed
    echo "Run preprocessing with munge.sh..."
    ./service/munge.sh -f ./data/latest-all.ttl.gz -d ./data/preprocessed -l de  > ./logs/log_munge_preprocessing.txt 2>&1
    checkSuccess $? ./data/preprocessed
else
    echo "Preprocessing with munge.sh already performed."
fi

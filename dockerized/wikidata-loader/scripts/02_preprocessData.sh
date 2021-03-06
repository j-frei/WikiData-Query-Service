#!/usr/bin/env bash

old_cwd=$(pwd)
cd $(dirname "$0")
source utils.sh

# Preprocessing with munge.sh
if [ ! -d ./data/preprocessed ]; then
    mkdir -p ./data/preprocessed
    mkdir -p ./logs
    echo "Run preprocessing with munge.sh..."
    ./service/munge.sh -f ./data/latest-all.ttl.gz -d ./data/preprocessed ${WIKI_LANG_PARAM} > ./logs/log_munge_preprocessing.txt 2>&1
    checkSuccess $? ./data/preprocessed
else
    echo "Preprocessing with munge.sh already performed."
fi

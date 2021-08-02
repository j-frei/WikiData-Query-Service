#!/usr/bin/env bash

old_cwd=$(pwd)
cd $(dirname "$0")
source utils.sh

# Download Wikipedia dump
if [ ! -f ./data/latest-all.ttl.gz ]; then
    mkdir -p ./data
    echo "Downloading Wikipedia RDF dump..."
    dump_url="https://dumps.wikimedia.org/wikidatawiki/entities/latest-all.ttl.gz"
    curl -X HEAD -I -s $dump_url >> ./data/latest-all.ttl.gz.header.txt
    checkSuccess $? ./data/latest-all.ttl.gz.header.txt
    wget --directory-prefix=./data -q --show-progress $dump_url
    checkSuccess $? ./data/latest-all.ttl.gz
else
    echo "Wikipedia dump already downloaded."
fi

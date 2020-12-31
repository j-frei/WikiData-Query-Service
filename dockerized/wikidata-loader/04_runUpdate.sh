#!/bin/bash

old_cwd=$(pwd)
cd $(dirname "$0")
source utils.sh

# Index update loading with runUpdate.sh
if [ ! -f ./data/.updatedData ]; then
    echo "Run updater script with runUpdate.sh.."
    ./service/runUpdate.sh -n wdq -h http://wikidata-query-service:9999 -l de -S
    checkSuccess $?
    touch ./data/.updatedData
else
    echo "Updater service with runUpdate.sh already performed."
fi
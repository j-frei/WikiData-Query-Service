#!/usr/bin/env bash

while true; do
    echo "Loop: Run updater script at $(date)..."
    /wikidata/service/runUpdate.sh -n wdq -h http://query-service:9999 -l "$WIKI_LANG" -S || true
    echo "Update script done... Sleep for ${WIKI_UPDATE_SLEEP_SEC} seconds"
    sleep "${WIKI_UPDATE_SLEEP_SEC}"
done
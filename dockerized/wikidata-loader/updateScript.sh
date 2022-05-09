#!/usr/bin/env bash

if [ -f "/.doUpdate" ]; then
    for pid in $(pidof -x updateScript.sh); do
        if [ $pid != $$ ]; then
            echo "[$(date)] : updateScript.sh : Process is already running with PID $pid"
            exit 0
        fi
    done

    echo "Running update..."
    while true; do
        echo "Loop: Run updater script at $(date)..."
        /wikidata/service/runUpdate.sh -n wdq -h http://query-service:9999 ${WIKI_LANG_PARAM} -S || true
        echo "Update script done... Sleep for ${WIKI_UPDATE_SLEEP_SEC} seconds"
        sleep "${WIKI_UPDATE_SLEEP_SEC}"
    done

else
    echo "Update disabled."
fi
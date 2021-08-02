#!/usr/bin/env bash

# Wait until server is up
echo "Waiting for blazegraph to be available..."
/waitForBlazegraph.sh

# Detect initial startup
if [ "$1" = "/usr/bin/sleep" ] && [ "$2" = "infinity" ]; then
    # Detect enabled update loop
    if [ -f "/.doUpdate"]; then
        # Async update loop
        echo "UpdateEntrypoint: Start update loop"
        echo "Trigger at: $(date)" >> /updateEntrypoint.log
        /bin/bash /updateEntrypoint.sh >> /updateEntrypoint.log 2>&1 &
    fi
fi

exec "$@"

#!/usr/bin/env bash

# check whether server is running...
until $(curl --output /dev/null --silent --head --fail http://query-service:9999/bigdata); do
    # Server is not running...
    echo "Server is not running... Waiting for 10 secs..."
    sleep 10
    echo -n "Checking availability..."
done

# Final check (can fail, if CTRL+C is sent)
if [ $(curl --output /dev/null --silent --head --fail http://query-service:9999/bigdata) ]; then
    echo "Server 'http://query-service:9999/bigdata' is not available"
    exit -1
else
    # Page is up and running!
    echo "Server 'http://query-service:9999/bigdata' is available :)"
fi

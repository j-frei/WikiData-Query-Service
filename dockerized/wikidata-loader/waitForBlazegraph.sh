#!/bin/bash

# check whether server is running...
while [ ! curl -Is http://wikidata-query-service:9999/bigdata 2>/dev/null | grep "HTTP/1.1" 1>/dev/null 2>&1 ]; do
    # Server is not running...
    echo "Server is not running... Waiting for 10 secs..."
    sleep 10
    echo -n "Checking availability..."
done

# Final check (can fail, if CTRL+C is sent)
if [ ! curl -Is http://wikidata-query-service:9999/bigdata 2>/dev/null | grep "HTTP/1.1" 1>/dev/null 2>&1 ]; then
    echo "Server 'http://wikidata-query-service:9999/bigdata' is not available"
    exit -1
else
    # Page is up and running!
    echo "Server 'http://wikidata-query-service:9999/bigdata' is available :)"
fi

#!/usr/bin/env bash

set -e

if [ ! -f "/wikidata/service/data/wikidata.jnl" ]; then
    echo "No wikidata file... Blazegraph will create a new file..."
fi

exec "$@"
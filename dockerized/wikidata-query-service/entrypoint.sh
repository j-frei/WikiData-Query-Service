#!/usr/bin/env bash

set -e

if [ ! -f "/wikidata/service/data/wikidata.jnl" ]; then
    echo "Initialize empty wikidata file"
    mv "/wikidata/service/wikidata.jnl" "/wikidata/service/data/wikidata.jnl"
fi

exec "$@"
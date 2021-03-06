#!/usr/bin/env bash

old_cwd=$(pwd)
cd $(dirname "$0")
set -eEu -o pipefail
source utils.sh

# Wait for server to be accessible
/waitForBlazegraph.sh

# Run data loading pipeline
echo "Step 01 - Download Data"
./01_downloadData.sh
echo "Step 02 - Preprocess Data"
./02_preprocessData.sh
echo "Step 03 - Load Data (Takes >12 days)"
./03_loadData.sh
echo "Step 04 - Update Data (Takes >12 days)"
./04_runUpdate.sh

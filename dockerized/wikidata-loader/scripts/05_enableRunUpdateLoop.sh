#!/usr/bin/env bash

if [ ! -f "/.doUpdate" ]; then
    echo "Enabling update loop.."
    touch "/.updatedData"
else
    echo "Update loop already enabled."
fi
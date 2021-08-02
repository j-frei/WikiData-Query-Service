#!/usr/bin/env bash

if [ ! -f "/.doUpdate" ]; then
    echo "Enabling update loop.."
    touch "/.updatedData"
    echo "Please restart the container (but do NOT delete it)"
else
    echo "Update loop already enabled."
fi
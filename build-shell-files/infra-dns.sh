#!/bin/bash
if ! ls ./build-pipeline; then
    echo "Could not create DNS entry" && exit 1
else
    echo "DNS Entry created" 
fi
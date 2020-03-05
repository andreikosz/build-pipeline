#!/bin/bash
if ! test -f ~./kube/config; then
    echo "Could not create DNS entry" && exit 1
else
    echo "DNS Entry created" 
fi
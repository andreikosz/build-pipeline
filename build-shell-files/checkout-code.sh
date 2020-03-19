#!/bin/bash
if ! git clone $1 app-folder;then
    echo "Could not clone code repo" && exit 1
else
    echo "Code repo cloned"
fi
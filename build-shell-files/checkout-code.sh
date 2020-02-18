#!/bin/bash
if ! git clone https://github.com/andreikosz/app-folder.git app-folder;then
    echo "Could not clone code repo" && exit 1
else
    echo "Code repo cloned"
fi
#!/bin/bash
if ! git clone https://github.com/andreikosz/java-vm-deploy.git;then
    echo "Could not clone code repo" && exit 1
else
    echo "Code repo cloned"
fi
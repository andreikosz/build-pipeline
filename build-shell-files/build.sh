#!/bin/bash
if [[ $1 = "java8" ]];then
    source build-pipeline/build-shell-files/java-shells/build-java8.sh
elif [[ $1 = "python3" ]];then
    source build-pipeline/build-shell-files/python-shells/build-python3.sh
fi
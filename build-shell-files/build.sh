#!/bin/bash
if [[ $1 = "java" ]];then
    source build-pipeline/build-shell-files/java-shells/build-java8.sh
elif [[ $1 = "python" ]];then
    source build-pipeline/build-shell-files/python-shells/build-python3.sh
fi
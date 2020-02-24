#!/bin/bash
if [[ $1 = "java8" ]];then
   source build-pipeline/build-shell-files/checkout-code-shells/checkout-java8-app.sh
elif [[ $1 = "python3" ]];then
    source build-pipeline/build-shell-files/checkout-code-shells/checkout-python3-app.sh
fi
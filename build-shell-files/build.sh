#!/bin/bash
if [[ $1 = "java" ]];then
    if ! (cd app-folder && gradle test bootJar && mv ./build/libs/*.jar ./build/libs/spring-boot-app.jar) ; then
        echo "Could not build code" && exit 1
    else
        echo "Code successfully build"
    fi
elif [[ $1 = "python" ]];then
    if ! (cd app-folder && mv ./*.py ./backend.py) ; then
        echo "Could not move python file" && exit 1
    else
        echo "Python file successfuly added"
    fi
fi
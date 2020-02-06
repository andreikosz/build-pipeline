#!/bin/bash
if ! (cd java-vm-deploy && gradle test bootJar && mv ./build/libs/*.jar ./build/libs/spring-boot-app.jar) ; then
    echo "Could not build code" && exit 1
else
    echo "Code successfully build"
fi
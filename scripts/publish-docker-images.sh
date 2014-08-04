#!/bin/bash

DOCKER_IMAGES=$(sudo docker images | grep kbence/cyberdojo- | awk '{ print $1 }')

for image in $DOCKER_IMAGES; do
  sudo docker push "$image"
done

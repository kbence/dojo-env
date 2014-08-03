#!/bin/bash

IMAGE_ROOT="/usr/src/cyberdojo/languages"

sanitize_image_name()
{
    echo $1 | sed 's/#/sharp/g; s/+/plus/g; s/[^A-Za-z0-9_-]/_/g' | tr 'A-Z' 'a-z'
}

if [ "$#" -gt 0 ]; then
  IMAGES="$@"
else
  IMAGES=$(ls $IMAGE_ROOT | grep -v build-essential)
fi

for image in $IMAGES; do
  if [ -f "$IMAGE_ROOT/$image/Dockerfile" -a -f "$IMAGE_ROOT/$image/manifest.json" ]; then
    image_name=$(sanitize_image_name "$image")
    image_tag="$DOCKER_USERNAME/cyberdojo-$image_name"
    echo Building docker image "$image_tag"...
    sudo docker build -t "$image_tag" "$IMAGE_ROOT/$image"
  fi
done

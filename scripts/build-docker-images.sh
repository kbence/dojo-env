#!/bin/bash

IMAGE_ROOT="/usr/src/cyberdojo/languages"
TEMPLATE_ROOT="/home/vagrant/templates"

sanitize_image_name()
{
    echo $1 | sed 's/#/sharp/g; s/+/plus/g; s/[^A-Za-z0-9_-]/_/g' | tr 'A-Z' 'a-z'
}

get_files()
{
  manifest=$1
  len=$(jq ".visible_filenames | length" "$manifest")

  for i in $(seq 0 $(($len-1))); do
    jq ".visible_filenames[$i]" "$manifest" | tr -d '"'
  done
}

if [ "$#" -gt 0 ]; then
  IMAGES="$@"
else
  IMAGES=$(ls $IMAGE_ROOT | grep -v build-essential)
fi

for image in $IMAGES; do
  manifest_file="$IMAGE_ROOT/$image/manifest.json"

  if [ -f "$IMAGE_ROOT/$image/Dockerfile" -a -f "$manifest_file" ]; then
    image_name=$(sanitize_image_name "$image")
    image_tag="$DOCKER_USERNAME/cyberdojo-$image_name"

    echo Building docker image "$image_tag"...
    sudo docker build -t "$image_tag" "$IMAGE_ROOT/$image"

    mkdir -p "$TEMPLATE_ROOT/$image_name"
    for file in $(get_files $manifest_file); do
      cp "$IMAGE_ROOT/$image/$file" "$TEMPLATE_ROOT/$image_name/"
    done
  fi
done

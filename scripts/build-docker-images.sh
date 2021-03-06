#!/bin/bash

IMAGE_ROOT="/usr/src/cyberdojo/languages"
TEMPLATE_ROOT="/home/vagrant/templates"

sanitize_image_name()
{
    echo $1 | sed 's/#/sharp/g; s/+/plus/g; s/[^A-Za-z0-9_-]/_/g' | tr 'A-Z' 'a-z'
}

get_files()
{
  ls $1 | grep -v build-docker-container.sh | \
          grep -v Dockerfile | \
          grep -v manifest.json |
          grep -v cyber-dojo.sh | \
          grep -v makefile
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
    image_dir="$IMAGE_ROOT/$image"
    for file in $(get_files $image_dir); do
      cp -v "$image_dir/$file" "$TEMPLATE_ROOT/$image_name/"
    done

    # fix missing shebang
    echo '#!/bin/bash' > "$TEMPLATE_ROOT/$image_name/cyber-dojo.sh"
    cat "$image_dir/cyber-dojo.sh" >> "$TEMPLATE_ROOT/$image_name/cyber-dojo.sh"

    if [ -f "$image_dir/makefile" ]; then
      cp "$image_dir/makefile" "$TEMPLATE_ROOT/$image_name/Makefile"
    fi
  fi
done

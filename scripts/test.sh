#!/bin/bash

cd $(dirname $0)/../.. && pwd && vagrant ssh --command \
    "sudo docker run -i -t -v '/home/vagrant/projects/PROJECTNAME:/project' kbence/cyberdojo-IMAGENAME /project/cyber-dojo.sh"


#!/bin/bash
# Find the path to a named volume
# docker volume inspect docker_ckan_home | jq -c '.[] | .Mountpoint'
# "/var/lib/docker/volumes/docker_ckan_config/_data"

#remove old versions
sudo apt-get purge docker-ce docker-ce-cli containerd.io

#remove images, containers, volumes or etc...
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd



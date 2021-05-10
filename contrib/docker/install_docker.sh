#!/bin/bash
# Find the path to a named volume
# docker volume inspect docker_ckan_home | jq -c '.[] | .Mountpoint'
# "/var/lib/docker/volumes/docker_ckan_config/_data"

#remove old versions
sudo apt remove docker docker-engine docker.io containerd runc

#setup the repository
sudo apt update
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

#add docker's official GPG key
echo `curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg`

#setup the repository, options: nightly || test || stable (add after "stable")
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

#install docker engine
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io

#create docker group and add user to group
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

#Configure Docker to start on boot
# sudo systemctl enable docker.service
# sudo systemctl enable containerd.service

#To disable this behavior, use disable instead.
# sudo systemctl disable docker.service
# sudo systemctl disable containerd.service

#Download docker-compose
echo `sudo curl -L "https://github.com/docker/compose/releases/download/1.29.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose -k`
#apply executable permissions
sudo chmod +x /usr/local/bin/docker-compose
#add to path
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose


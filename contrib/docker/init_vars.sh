#!/bin/bash
# Find the path to a named volume
# docker volume inspect docker_ckan_home | jq -c '.[] | .Mountpoint'
# "/var/lib/docker/volumes/docker_ckan_config/_data"

export VOL_CKAN_HOME=`sudo docker volume inspect docker_ckan_home | jq -r -c '.[] | .Mountpoint'`
echo $VOL_CKAN_HOME

export VOL_CKAN_CONFIG=`sudo docker volume inspect docker_ckan_config | jq -r -c '.[] | .Mountpoint'`
echo $VOL_CKAN_CONFIG

export VOL_CKAN_STORAGE=`sudo docker volume inspect docker_ckan_storage | jq -r -c '.[] | .Mountpoint'`
echo $VOL_CKAN_STORAGE

#O script informado no site informa o comando abaixo o qual apresenta um erro, assim houve a adequacao logo a seguir.
#echo `sudo docker exec ckan /usr/local/bin/ckan-paster --plugin=ckan datastore set-permissions -#c /etc/ckan/production.ini | docker exec -i db psql -U ckan`

echo `sudo docker exec -d ckan /usr/local/bin/ckan-paster --plugin=ckan datastore set-permissions -c /etc/ckan/production.ini | sudo docker exec -i db psql -U ckan`

sudo cp ./production.ini $VOL_CKAN_CONFIG

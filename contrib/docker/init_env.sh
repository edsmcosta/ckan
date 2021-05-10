#!/bin/bash
# Find the path to a named volume
# docker volume inspect docker_ckan_home | jq -c '.[] | .Mountpoint'
# "/var/lib/docker/volumes/docker_ckan_config/_data"

###executar seguinte comando antes do script 
#sudo apt install jq

### para adicionar um certificado devido ao erro ADD failed: Get https://raw.githubusercontent.com/apache/lucene-solr/releases/lucene-solr/6.6.5/solr/server/solr/configsets/basic_configs/conf/currency.xml: ### x509: certificate signed by unknown authority

##save the cert to the file , like the command above (the port is crucial, no need for the protocol)
#openssl s_client -showcerts -connect [registry_address]:[registry_port] < /dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > ca.crt
##copy it to /usr/local/share/ca-certificates/
#sudo cp ca.crt /usr/local/share/ca-certificates/
##run update-ca-certificates
#sudo update-ca-certificates
##restart docker
#sudo service docker restart

###Build and run services
#echo `cd ckan/contrib/docker`
#echo `sudo docker-compose up -d --build`

##restart service
echo `sudo docker-compose restart ckan`

###Create virtual variables
export VOL_CKAN_HOME=`sudo docker volume inspect docker_ckan_home | jq -r -c '.[] | .Mountpoint'`
echo $VOL_CKAN_HOME

export VOL_CKAN_CONFIG=`sudo docker volume inspect docker_ckan_config | jq -r -c '.[] | .Mountpoint'`
echo $VOL_CKAN_CONFIG

export VOL_CKAN_STORAGE=`sudo docker volume inspect docker_ckan_storage | jq -r -c '.[] | .Mountpoint'`
echo $VOL_CKAN_STORAGE

###execute the built-in setup script against the db container:
### O script informado no site contem o comando abaixo o qual apresenta um erro, assim houve a adequacao logo a seguir.
### sudo docker exec ckan /usr/local/bin/ckan-paster --plugin=ckan datastore set-permissions -c /etc/ckan/production.ini | docker exec -i db psql -U ckan
echo `sudo docker exec -d ckan /usr/local/bin/ckan-paster --plugin=ckan datastore set-permissions -c /etc/ckan/production.ini | sudo docker exec -i db psql -U ckan`

###apply custom configuration
sudo cp ./production.ini $VOL_CKAN_CONFIG/production.ini

##restart service
echo `sudo docker-compose restart ckan`

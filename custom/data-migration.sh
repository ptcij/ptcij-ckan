#!/bin/sh

docker exec ckan sh  -c "tar xvf /backup/ckan_backup.tar && rm /etc/ckan/default/ckan.ini && /ckan-entrypoint.sh"
docker exec db sh -c "tar xvf /backup/db_backup.tar"
docker restart db ckan
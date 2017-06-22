# PTCIJ CKAN Project


### Docker Set up
To run build & run the detached servers
* `docker-compose up --build -d`

To open ckan interactive shell prompt
* `docker exec -i -t ckan /bin/bash`

To create admin (from host) 
* `docker exec -it ckan ckan-paster --plugin=ckan sysadmin add admin -c /etc/ckan/default/ckan.ini`

To run up into App server
* `docker exec -i -t mintegration_django_1 /bin/bash` (sudo might be needed)
* `python manage.py migrate`
* `python manage.py runserver 0.0.0.0:8000`

To load initial data (while in app container)
* `python manage.py loaddata initial_data`

DB DUMP
sudo -u postgres pg_dump --format=custom -d ckan_default > ckan.dump

DB Restore
paster db clean -c /etc/ckan/default/production.ini
sudo -u postgres pg_restore --clean --if-exists -d ckan_default < ckan.dump

ckan-paster serve --reload /etc/ckan/default/ckan.ini

https://github.com/ckan/ckanext-harvest

DB & App backup
docker run --rm --volumes-from db -v $(pwd):/backup ubuntu tar cvf /backup/backup.tar /etc/postgresql /var/log/postgresql /var/lib/postgresql
docker run --rm --volumes-from ckan -v $(pwd):/backup ubuntu tar cvf /backup/ckan_backup.tar /etc/ckan/default /var/lib/ckan

DB & APP restore
docker exec ckan sh  -c "tar xvf /backup/ckan_backup.tar && rm /etc/ckan/default/ckan.ini && /ckan-entrypoint.sh"
docker exec db sh -c "tar xvf /backup/db_backup.tar"
docker restart db ckan

docker stop db solr redis ckan
docker rm db solr redis ckan


ckan-paster --plugin=ckan config-tool "$CONFIG" -e "ckan.template_head_end = <link rel='stylesheet' href='${CKAN_STORAGE_PATH}/resources/css/style.css' type='text/css'>"

# Host IP Address
hostname -I | awk '{print $1}'
export HOST_IP=...
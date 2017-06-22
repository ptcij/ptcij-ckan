#!/bin/sh

ip () {
  hostname -I | awk '{print $1}' | xargs echo
}

sed -i "s/localhost/$(ip)/g" /usr/local/src/ptcij-ckan/Dockerfile
cd /usr/local/src/ptcij-ckan/ && docker-compose up --build

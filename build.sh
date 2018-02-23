#!/bin/bash

CONTAINER=grafana_temp_build
BUILD_DIR=/grafana_temp/src/github.com/grafana/grafana/

# Initiating build in a centos container
docker run --name ${CONTAINER} -dti docker.io/centos
docker cp grafana_build_centos.sh ${CONTAINER}:/grafana_build_centos.sh 
docker exec -it ${CONTAINER} /grafana_build_centos.sh

# Copy assets locally
docker cp ${CONTAINER}:${BUILD_DIR}/assets .

# Build grafana image
docker build . -t  grafana-musl-docker

# Cleanup
docker rm -f ${CONTAINER}
docker rmi centos
rm -rf assets

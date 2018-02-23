#!/bin/bash

BUILD_CONTAINER=grafana_temp_build
GRAFANA_CONTAINER=grafana-musl-docker
BUILD_DIR=/grafana_temp/src/github.com/grafana/grafana/

# Initiating build in a centos container
docker run --name ${BUILD_CONTAINER} -p 3000:3000 -dti docker.io/centos
docker cp grafana_build_centos.sh ${BUILD_CONTAINER}:/grafana_build_centos.sh 
docker exec -it ${BUILD_CONTAINER} /grafana_build_centos.sh

# Copy assets locally
docker cp ${BUILD_CONTAINER}:${BUILD_DIR}/assets .

# Build grafana image
docker build . -t  ${GRAFANA_CONTAINER}

# Cleanup
docker rm -f ${BUILD_CONTAINER}
docker rmi centos
rm -rf assets
docker run -d -p 3000:3000 --name ${GRAFANA_CONTAINER}-`date +%s` ${GRAFANA_CONTAINER}

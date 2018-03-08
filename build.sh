#!/bin/bash

if [ $# -ne 1 ]; then
    echo "USAGE: $0 <latest|stable>"
fi

case $1 in
    "latest")
        BUILD_SCRIPT=grafana_build_centos.sh
        ;;
    "stable")
	BUILD_SCRIPT=grafana_build_centos_stable.sh
	;;
    *)
	echo "USAGE: $0 <latest|stable>"
	;;
esac


BUILD_CONTAINER=grafana_temp_build
GRAFANA_CONTAINER=grafana-musl-docker
BUILD_DIR=/grafana_temp/src/github.com/grafana/grafana/

# Initiating build in a centos container
docker run --name ${BUILD_CONTAINER} -p 3000:3000 -dti docker.io/centos
docker cp $BUILD_SCRIPT ${BUILD_CONTAINER}:/$BUILD_SCRIPT
docker exec -it ${BUILD_CONTAINER} /$BUILD_SCRIPT

# Copy assets locally
docker cp ${BUILD_CONTAINER}:${BUILD_DIR}/assets .
docker cp ${BUILD_CONTAINER}:/etc/pki/ca-trust/extracted .
docker cp ${BUILD_CONTAINER}:/etc/pki/tls/certs .

# Build grafana image
docker build . -t  ${GRAFANA_CONTAINER}

# Cleanup
docker rm -f ${BUILD_CONTAINER}
docker rmi centos
rm -rf assets extracted certs
docker run -d -p 3000:3000 --name ${GRAFANA_CONTAINER}-`date +%s` ${GRAFANA_CONTAINER}

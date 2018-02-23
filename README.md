# grafana-musl-docker
A statically linked compiled grafana container built from scratch

This will spin up a docker.io/centos container, download the laters grafana source code and create statically linked binaries and gather assets. After this, a docker image will be created from scratch using the assets and binaries

Please note that all the configs are default and if you wish to add custom configs, you will have to edit the Dockerfile

How to use:

Simply clone this repo and run ./build.sh script with no args.

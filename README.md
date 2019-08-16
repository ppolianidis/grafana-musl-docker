# grafana-musl-docker
A statically linked compiled grafana container built from scratch

- This solution in not the most elegant but it works :)

A docker.io/centos container will be spinned up where the build will be performed. It will download the laters grafana source code and create statically linked binaries and gather assets. After this, a docker image will be created from scratch using the assets and binaries

In order to be able to compile as statically linked binaries, musl is used instead of glibc

Please note that all the configs are default and if you wish to add custom configs, you will have to edit the Dockerfile

How to use:

Simply clone this repo and run ./build.sh script with the appropriate args:

./build.sh latest # builds grafana from the latest repo
./build.sh stable # builds grafana from the latest stable repo


test change

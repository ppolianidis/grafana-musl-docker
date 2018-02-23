#!/bin/bash

# Creating a new working directory

mkdir grafana_temp
cd grafana_temp

# Download and install GO

curl -O https://dl.google.com/go/go1.9.4.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.9.4.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin

# Setting up GO env
export GOPATH=`pwd`


# Downloading and installing dependancies

yum update -y
yum install ruby-devel gcc gcc-c++ make rpm-build rubygems libtool sudo -y
curl --silent --location https://rpm.nodesource.com/setup_8.x | sudo bash -
yum install nodejs initscripts fontconfig git autoconf autogen automake ca-certificates -y
gem install --no-ri --no-rdoc fpm
npm install -g yarn

# Download and compile musl

curl -O http://www.musl-libc.org/releases/musl-latest.tar.gz
tar xfz musl-latest.tar.gz
cd musl-*
./configure
make && make install
cd -

# Download latest grafana from git

go get github.com/grafana/grafana

# Build grafana

cd $GOPATH/src/github.com/grafana/grafana
sed -i "s/\"-w\"/\"-w -linkmode external -extldflags '-static'\"/g" build.go
export CGO_ENABLED=1
export CC=/usr/local/musl/bin/musl-gcc
go run build.go setup
go run build.go build

# Build the frontend assets

npm install -g yarn
yarn install --pure-lockfile
nohup npm run watch &
sleep 60

mkdir -p assets/bin
cp bin/grafana-server assets/bin
cp bin/grafana-cli assets/bin
strip assets/bin/*
cp -r public vendor conf assets/

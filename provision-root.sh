#!/usr/bin/env bash

set -o errexit
set -o pipefail

if [ -z $1 ]; then
  HLF_VERSION=1.4.1
else
  HLF_VERSION=$1
fi

if [ ${HLF_VERSION:0:4} = '1.2.' -o ${HLF_VERSION:0:4} = '1.3.' -o ${HLF_VERSION:0:4} = '1.4.' ]; then
  export GO_VERSION=1.10.4
elif [ ${HLF_VERSION:0:4} = '1.1.' ]; then
  export GO_VERSION=1.9.7
else
  >&2 echo "Unexpected HLF_VERSION ${HLF_VERSION}"
  >&2 echo "HLF_VERSION must be a 1.1.x, 1.2.x, 1.3.x, or 1.4.x version"
  exit 1
fi

# APT setup for docker packages
# gpg keys listed at https://github.com/nodejs/node#release-team
apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-keys 9DC858229FC7DD38854AE2D88D81803C0EBFCD88
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable"
apt-cache policy docker-ce

# Update package lists
apt-get update

# Install jq (nice to have when there's JSON everywhere!)
apt-get -y --no-upgrade install jq

# Install unzip (useful for .card files)
apt-get -y --no-upgrade install unzip

# Install python 2 (required for node-gyp)
apt-get -y --no-upgrade install python-minimal

# Install Git
apt-get -y --no-upgrade install git

# Install nvm dependencies
apt-get -y --no-upgrade install build-essential libssl-dev

# Ensure that CA certificates are installed
apt-get -y --no-upgrade install apt-transport-https ca-certificates

# Install docker
apt-get -y --no-upgrade install docker-ce

# Add user to docker group
usermod -aG docker vagrant

# Install docker compose
if [ ! -x /usr/local/bin/docker-compose ]; then
  curl --silent --show-error -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose
fi

# Install go
if [ ! -d /usr/local/go ]; then
  GO_VERSION=1.10.4
  curl --silent --show-error -L "https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz" -o "/tmp/go${GO_VERSION}.linux-amd64.tar.gz"
  tar -C /usr/local -xzf "/tmp/go${GO_VERSION}.linux-amd64.tar.gz"
  rm "/tmp/go${GO_VERSION}.linux-amd64.tar.gz"
fi

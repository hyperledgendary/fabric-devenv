#!/usr/bin/env bash

set -o errexit
set -o pipefail

if [ -z $1 ]; then
  HLF_VERSION=2.2.0
else
  HLF_VERSION=$1
fi

if [ ${HLF_VERSION:0:4} = '2.2.' -o ${HLF_VERSION:0:4} = '2.3.' -o ${HLF_VERSION:0:4} = '2.4.' ]; then
  export GO_VERSION=1.14.11
elif [ ${HLF_VERSION:0:4} = '2.0.' -o ${HLF_VERSION:0:4} = '2.1.' ]; then
  export GO_VERSION=1.13.15
elif [ ${HLF_VERSION:0:4} = '1.2.' -o ${HLF_VERSION:0:4} = '1.3.' -o ${HLF_VERSION:0:4} = '1.4.' ]; then
  export GO_VERSION=1.10.4
elif [ ${HLF_VERSION:0:4} = '1.1.' ]; then
  export GO_VERSION=1.9.7
else
  >&2 echo "Unexpected HLF_VERSION ${HLF_VERSION}"
  >&2 echo "HLF_VERSION must be a 1.1.x, 1.2.x, 1.3.x, 1.4.x, 2.0.x, 2.1.x, 2.2.x, 2.3.x, or 2.4.x version"
  exit 1
fi

# APT setup for docker packages
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
apt-cache policy docker-ce

# APT setup for kubectl
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"

# Update package lists
apt-get update

# Install jq
apt-get -y --no-upgrade install jq

# Install unzip
apt-get -y --no-upgrade install unzip

# Install java
apt-get -y --no-upgrade install default-jdk

# Install python 3.8
apt-get -y --no-upgrade install python3.8-minimal python3.8-venv python3.8-dev python3-pip

# Install sponge
apt-get -y --no-upgrade install moreutils

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
  curl --fail --silent --show-error -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  chmod 755 /usr/local/bin/docker-compose
fi

# Install kubectl
apt-get -y --no-upgrade install kubectl

# Install kind
KIND_VERSION=0.11.1
if [ ! -x "/usr/local/bin/kind" ]; then
  curl --fail --silent --show-error -L "https://kind.sigs.k8s.io/dl/v${KIND_VERSION}/kind-linux-amd64" -o /usr/local/bin/kind
  chmod 755 /usr/local/bin/kind
fi

# Install k9s
K9S_VERSION=0.25.3
if [ ! -x "/usr/local/bin/k9s" ]; then
  curl --fail --silent --show-error -L "https://github.com/derailed/k9s/releases/download/v${K9S_VERSION}/k9s_Linux_x86_64.tar.gz" -o "/tmp/k9s_Linux_x86_64.tar.gz"
  tar -zxf "/tmp/k9s_Linux_x86_64.tar.gz" -C /usr/local/bin k9s
  chown root:root /usr/local/bin/k9s
  chmod 755 /usr/local/bin/k9s
fi

# Install go
if [ ! -d /usr/local/go ]; then
  curl --fail --silent --show-error -L "https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz" -o "/tmp/go${GO_VERSION}.linux-amd64.tar.gz"
  tar -C /usr/local -xzf "/tmp/go${GO_VERSION}.linux-amd64.tar.gz"
  rm "/tmp/go${GO_VERSION}.linux-amd64.tar.gz"
fi

# Install maven
MAVEN_VERSION=3.6.3
if [ ! -d /opt/apache-maven-${MAVEN_VERSION} ]; then
  curl --fail --silent --show-error -L "https://www-eu.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz" -o "/tmp/apache-maven-${MAVEN_VERSION}-bin.tar.gz"
  tar -C /opt -xzf "/tmp/apache-maven-${MAVEN_VERSION}-bin.tar.gz"
  rm "/tmp/apache-maven-${MAVEN_VERSION}-bin.tar.gz"
  cat \
<< END-MAVEN-SH > /etc/profile.d/maven.sh
export MAVEN_HOME=/opt/apache-maven-${MAVEN_VERSION}
export PATH=\$PATH:\$MAVEN_HOME/bin
END-MAVEN-SH
  chmod +x /etc/profile.d/maven.sh
fi

# Install gradle
GRADLE_VERSION=5.4.1
if [ ! -d /opt/gradle-${GRADLE_VERSION} ]; then
  curl --fail --silent --show-error -L "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" -o "/tmp/gradle-${GRADLE_VERSION}-bin.zip"
  unzip -d /opt /tmp/gradle-${GRADLE_VERSION}-bin.zip
  rm "/tmp/gradle-${GRADLE_VERSION}-bin.zip"
  cat \
<< END-GRADLE-SH > /etc/profile.d/gradle.sh
export GRADLE_HOME=/opt/gradle-${GRADLE_VERSION}
export PATH=\$PATH:\$GRADLE_HOME/bin
END-GRADLE-SH
  chmod +x /etc/profile.d/gradle.sh
fi

# Install protoc
PROTOC_VERSION=3.9.1
if [ ! -x "/usr/local/bin/protoc" ]; then
  curl --fail --silent --show-error -L "https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOC_VERSION}/protoc-${PROTOC_VERSION}-linux-x86_64.zip" -o "/tmp/protoc-${PROTOC_VERSION}-linux-x86_64.zip"
  unzip "/tmp/protoc-${PROTOC_VERSION}-linux-x86_64.zip" -d "/tmp/protoc-${PROTOC_VERSION}-linux-x86_64"
  rm "/tmp/protoc-${PROTOC_VERSION}-linux-x86_64.zip"
  mv /tmp/protoc-${PROTOC_VERSION}-linux-x86_64/bin/* /usr/local/bin/
  mv /tmp/protoc-${PROTOC_VERSION}-linux-x86_64/include/* /usr/local/include/
  rm -Rf "/tmp/protoc-${PROTOC_VERSION}-linux-x86_64"
fi

# Install ccmetadata
CCMETADATA_VERSION=0.2.0
if [ ! -x "/usr/local/bin/ccmetadata" ]; then
  curl --fail --silent --show-error -L "https://github.com/hyperledgendary/ccmetadata/releases/download/v${CCMETADATA_VERSION}/ccmetadata-Linux-X64.tgz" -o "/tmp/ccmetadata-Linux-X64.tgz"
  tar -zxf "/tmp/ccmetadata-Linux-X64.tgz" -C /usr/local/bin ccmetadata
  chown root:root /usr/local/bin/ccmetadata
  chmod 755 /usr/local/bin/ccmetadata
fi

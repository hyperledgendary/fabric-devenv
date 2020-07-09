#!/usr/bin/env bash

set -o errexit
set -o pipefail

if [ -z $1 ]; then
  HLF_VERSION=2.2.0
else
  HLF_VERSION=$1
fi

THIRDPARTY_IMAGE_VERSION=0.4.15

if [ ${HLF_VERSION:0:2} = '2.' ]; then
  CA_VERSION=1.4.4
  SAMPLE_BRANCH=master
  NODE_VERSION=12.14.0
else
  CA_VERSION=$HLF_VERSION
  SAMPLE_BRANCH=v${HLF_VERSION}
  NODE_VERSION=8.9.0
fi

# Install NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] || curl --fail --silent --show-error -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.3/install.sh | bash
. "$NVM_DIR/nvm.sh"

# Install node and npm
nvm which ${NODE_VERSION} >/dev/null 2>&1 || nvm install ${NODE_VERSION}

nvm use ${NODE_VERSION}
nvm alias default ${NODE_VERSION}
echo "default" > $HOME/.nvmrc

# Install useful node modules
npm ls -g yo >/dev/null 2>&1 || npm install -g yo
npm ls -g generator-fabric >/dev/null 2>&1 || npm install -g generator-fabric

# Install Hyperledger Fabric binaries and docker images
if [ ! -d "$HOME/fabric" ]; then
  sg docker "curl -sSL https://raw.githubusercontent.com/hyperledger/fabric/master/scripts/bootstrap.sh | bash -s -- $HLF_VERSION $CA_VERSION $THIRDPARTY_IMAGE_VERSION"
fi

# Set up Go workspace
if [ ! -d "$HOME/go/src" ]; then
  mkdir -p "$HOME/go/src"
fi

# Clone Hyperledger Fabric into Go workspace
if [ ! -d "$HOME/go/src/github.com/hyperledger/fabric" ]; then
  mkdir -p "$HOME/go/src/github.com/hyperledger"
  pushd "$HOME/go/src/github.com/hyperledger"
  git clone --branch v${HLF_VERSION} --depth 1 https://github.com/hyperledger/fabric.git
  popd
fi

# Add symlink to Fabric Samples in Go workspace
if [ ! -h "$HOME/fabric-samples" ]; then
  mkdir -p "$HOME/go/src/github.com/hyperledger"
  ln -s "$HOME/fabric-samples" "$HOME/go/src/github.com/hyperledger/fabric-samples"
fi

# Add python virtual environment for ansible
if [ ! -h "$HOME/ansible-venv" ]; then
  python3.8 -m venv ansible-venv
  source $HOME/ansible-venv/bin/activate
  pip install wheel
  pip install ansible
  pip install docker
fi

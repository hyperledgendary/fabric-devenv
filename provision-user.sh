#!/usr/bin/env bash

set -o errexit
set -o pipefail

if [ -z $1 ]; then
  HLF_VERSION=1.2.0
else
  HLF_VERSION=$1
fi

# Install NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] || curl --silent --show-error -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.3/install.sh | bash
. "$NVM_DIR/nvm.sh"

# Install node and npm
DEFAULT_NODE_VERSION=8.9.0
nvm which ${DEFAULT_NODE_VERSION} >/dev/null 2>&1 || nvm install ${DEFAULT_NODE_VERSION}

nvm use ${DEFAULT_NODE_VERSION}
nvm alias default ${DEFAULT_NODE_VERSION}

# Install Hyperledger Fabric samples, binaries and docker images
if [ ! -d "$HOME/fabric" ]; then
  mkdir -p "$HOME/fabric"
  pushd "$HOME/fabric"
  curl -sSL https://raw.githubusercontent.com/hyperledger/fabric/master/scripts/bootstrap.sh | bash -s $HLF_VERSION
  popd
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

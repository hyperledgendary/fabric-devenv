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

# Set up Go workspace
if [ ! -d "$HOME/go/src" ]; then
  mkdir -p "$HOME/go/src"
fi

# Download Hyperledger Fabric
if [ ! -d "$HOME/go/src/github.com/hyperledger/fabric" ]; then
  curl --silent --show-error -L "https://github.com/hyperledger/fabric/archive/v${HLF_VERSION}.tar.gz" -o "/tmp/v${HLF_VERSION}.tar.gz"
  mkdir -p "$HOME/go/src/github.com/hyperledger"
  tar -C "$HOME/go/src/github.com/hyperledger" -xzf "/tmp/v${HLF_VERSION}.tar.gz"
  mv "$HOME/go/src/github.com/hyperledger/fabric-${HLF_VERSION}" "$HOME/go/src/github.com/hyperledger/fabric"
  rm "/tmp/v${HLF_VERSION}.tar.gz"
fi

#!/usr/bin/env bash

# Install NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] || curl --silent --show-error -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.3/install.sh | bash
. "$NVM_DIR/nvm.sh"

# Install node and npm
DEFAULT_NODE_VERSION=8.9.0
nvm which ${DEFAULT_NODE_VERSION} >/dev/null 2>&1 || nvm install ${DEFAULT_NODE_VERSION}

nvm use ${DEFAULT_NODE_VERSION}
nvm alias default ${DEFAULT_NODE_VERSION}

#!/bin/bash

# Install NVM (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# Source NVM script to start using it in the current shell
source ~/.nvm/nvm.sh

# Install the latest LTS version of Node.js
nvm install --lts

nvm install 14.20.0
nvm install 16.14.2
nvm install 18.13.0

# Set the installed version as the default Node.js version
nvm alias default v16.14.2

# Print Node.js and NPM versions to confirm installation
node --version
npm --version

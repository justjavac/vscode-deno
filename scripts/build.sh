#!/usr/bin/env bash

##=========
# Copy form vscode-ng-language-service
##=========

set -ex -o pipefail

# Enable extended pattern matching features
shopt -s extglob

# Clean up from last build
rm -rf client/out
rm -rf server/out
rm -rf dist
rm -rf **/*.tsbuildinfo

# Build the client and server
yarn run compile

# Copy files to package root
cp package.* yarn.lock deno.png CHANGELOG.md README.md dist
cp -r schemas dist
# Copy files to client directory
cp client/package.json client/yarn.lock dist/client
# Copy files to server directory
cp server/package.json server/yarn.lock dist/server

pushd dist
yarn install --production --ignore-scripts

pushd client
yarn install --production --ignore-scripts
popd

pushd server
yarn install --production --ignore-scripts
popd

sed -i -e 's#./client/out/extension#./client#' package.json
../node_modules/.bin/vsce package --yarn --out deno.vsix

popd

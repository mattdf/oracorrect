#!/usr/bin/env bash

#add swap
dd if=/dev/zero of=/swap bs=1M count=1024
mkswap /swap
swapon /swap


#for geth and cpp-ethereum
apt-get install software-properties-common
add-apt-repository -y ppa:ethereum/ethereum
add-apt-repository -y ppa:ethereum/ethereum-qt


#update
apt-get update

#get nodejs
curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash -
apt-get install -y nodejs
apt-get install -y build-essential

apt-get install -y ethereum
apt-get install -y cpp-ethereum
npm install -g dapple
npm install -g ethereumjs-testrpc
npm install -g mocha
npm install -g node-inspector
npm install -g solc

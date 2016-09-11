#!/bin/bash -e

echo This script is only included for reference, so you can see how the miners work.
exit 1

NETWORKID=909
DATADIR=~/.ethereum-edgware-data-$NETWORKID

mkdir -p $DATADIR
cp ./static-nodes.json $DATADIR
geth --datadir $DATADIR init ./genesis-block-edgware.json
HOSTNAME=$(hostname)
ETHERBASE=0x0000000000000000000000000000$(ifconfig en0 | grep ether | awk '{print $2}' | sed 's/://g')
geth --datadir $DATADIR --nat none --networkid $NETWORKID --bootnodes leave-me-alone --rpc --rpcaddr 0.0.0.0 --rpccorsdomain '*' --etherbase $ETHERBASE js mineOnDemand.js

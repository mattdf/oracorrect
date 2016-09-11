#!/bin/bash -e

VERIFIED_VERSION=1.4.11-stable-fed692f6
if ! geth version | grep $VERIFIED_VERSION ; then
	echo ''
	echo '***********************************************************************'
    echo "N.B. This is only verified against geth version $VERIFIED_VERSION."
    echo -n 'You have '
    geth version | grep ^Version:
    echo "If you encounter problems please try $VERIFIED_VERSION instead."
	echo '***********************************************************************'
	echo ''
fi

NETWORKID=909
DATADIR=~/.ethereum-edgware-data-$NETWORKID

mkdir -p $DATADIR
cp ./static-nodes.json $DATADIR
geth --datadir $DATADIR init ./genesis-block-edgware.json
geth --datadir $DATADIR --nat none --networkid $NETWORKID --bootnodes leave-me-alone --rpc --rpcaddr 0.0.0.0 --rpccorsdomain '*' --unlock 0xc398f897de0c263b25526872c89bf7f2a7e068ec --password pass console

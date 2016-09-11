
# Edgware blockchain

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  

- [Summary](#summary)
- [Ether supply](#ether-supply)
- [Access](#access)
  - [RPC](#rpc)
  - [Run a geth node](#run-a-geth-node)
  - [Run a different Ethereum client](#run-a-different-ethereum-client)
- [Etiquette](#etiquette)
- [Support](#support)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Summary

*Edgware* is a short-lived private *Ethereum* blockchain that will run during the *[HackETHon](https://hackethon.thomsonreuters.com/)*.

Block time should stay very small (i.e. transactions should be mined very quickly) for the duration of the HackETHon, because:
- the blockchain is very new
- genesis difficulty is very low
- mining happens only when there are transactions to process (Thomson Reuters is running the miners)

All our nodes on Edgware are running *geth 1.4.11-stable-fed692f6* (the head of the *master* branch at time of writing this). Compatibility with other versions or other *Ethereum* clients has not been verified.

Availability of the Thomson Reuters hosted nodes after the HackETHon isn't guaranteed.

## Ether supply
You can acquire up to 100 Ether for any account by sending a HTTP GET to (e.g. browse to):

https://blockone-faucet.tr-api-services.net/v1/send/100/ether-to/0x53875825f820a5003d6c41c5ad6b2af6937d2132/on/edgware

.. obviously substituting the address you want to fund. After the transaction to transfer the Ether has been mined, the request will complete with an informative message.

## Access
### RPC
JSON RPC ports are available at:
- http://10.3.3.21:8545
- https://blockone-edgware-chain-one-rpc.tr-api-services.net
- https://blockone-edgware-chain-two-rpc.tr-api-services.net

The first one is preferable for responsiveness as it's on the HackETHon temporary LAN.

### Running a geth node
Install or build a recent geth binary- v1.4.11 is recommended. Make sure it's in your path.

[Here is a zipfile of setup files](edgware.zip). Unzip it somewhere and run ```./edgware-node.sh```. The invoked geth will connect to the Edgware blockchain and sync blocks, but not do any mining.

This works on OSX and should work on Linux. If you need support for other platforms your best bet is to put a request on the [Edgware Slack channel](https://hackethon2016.slack.com/messages/edgware/).

#### What the edgware-node.sh script does

- Creates a new datadir for Edgware - ```~/.ethereum-edgware-data-909```
- Copies the ```static-nodes.json``` file into it (this mechanism is more reliable than passing node addresses through the --bootnodes argument)
- Initialises the genesis block from ```genesis-block-edgware.json```
- Starts geth with:
   - no NAT traversal (speeds things up, presumably you don't need it)
   - the Edgware network ID (909)
   - ```--bootnodes``` argument set to junk (observed to be the *only* way to stop it reaching out to the public server addresses hardwired into geth)
   - open RPC port on all interfaces, with CORS domain '*' (so browsers don't complain about attaching to it)
   - interactive console


### Running a different Ethereum client
If you want to run a node other than geth, the important properties of this blockchain are:

- Homestead mode from block 0 (so this low-block-numbered blockchain behaves like Homestead)
- Network ID: 909
- Genesis block: see ```genesis-block-edgware.json```
- Don't reach out to public (default) boot nodes- only try to connect to those listed in 'static-nodes.json'
- No mining!

### Statistics
An eth-netstats server is running at https://blockone-edgware-stats.tr-api-services.net/

## Etiquette
Please don't run miners on Edgware. 
Thomson Reuters is running mining servers that will start mining when there are pending transactions, which will allow us to keep block time short, difficulty low and transaction processing latency low. So it's particularly important that you don't run nodes that mine continually- as this would cause difficulty to creep up til the blocktime target of 13 seconds is reached and the performance of everyone's DApps will suffer.

## Support
[HackETHon Edgware Slack channel](https://hackethon2016.slack.com/messages/edgware/)

## Why "Edgware"?
A London connection. Like "Morden", it's a place you might wake up if ever you fall asleep on the Northern Line.

var net = require('net');
var fs = require('fs');
var Web3 = require('web3');
var web3 = new Web3();


function deploy(contractName, callback){
	var abi = JSON.parse(contractInfos[contractName]["interface"]);
	var code = contractInfos[contractName]["bytecode"];

	console.log("--------------------- " + contractName + " -------------------------");
	console.log(abi);
	console.log("---------------------------------------------------");
	var owner = "0xc398f897de0c263b25526872c89bf7f2a7e068ec";

	var sent = false;
	var Contract = web3.eth.contract(abi);
	Contract.new({data:code,gas:3000000,from:owner}, function(err,contract){
		if(err){
			console.log("ERROR",err);
			if(!sent){
				callback(err);
				sent = true;
			}
		}else{
			if(!contract.address) {
					console.log("hash for " + contractName,contract.transactionHash);
					if(!sent){
						callback(null);
					}
					sent = true;
			} else {
					console.log("address for " + contractName,contract.address);
			}
		}
		
		
	});
}

var client = new net.Socket();
web3.setProvider(new web3.providers.IpcProvider("/home/vagrant/.ethereum-edgware-data-909/geth.ipc",client));

var contents = fs.readFileSync('compiled_contracts.json').toString();
var contractInfos = JSON.parse(contents);

var contracts = ["Oracorrect","OraclizeOracle","OraclizeOracle","OraclizeOracle"];

function deployNext(err){
	if(err){
		console.error(err);
	}
	if(contracts.length == 0){
		return;
	}
	var contractName = contracts[0];
	contracts.shift();
	deploy(contractName, deployNext);
}

deployNext(null);





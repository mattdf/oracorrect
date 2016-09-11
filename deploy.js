var net = require('net');
var fs = require('fs');
var Web3 = require('web3');
var web3 = new Web3();

var client = new net.Socket();
web3.setProvider(new web3.providers.IpcProvider("/home/vagrant/.ethereum-edgware-data-909/geth.ipc",client));

var contents = fs.readFileSync('compiled_contracts.json').toString();
var contractInfos = JSON.parse(contents);
var abi = JSON.parse(contractInfos["Oracorrect"]["interface"]);
var code = contractInfos["Oracorrect"]["bytecode"];

console.log("--------------------- abi -------------------------");
console.log(abi);
console.log("---------------------------------------------------");
var owner = "0xc398f897de0c263b25526872c89bf7f2a7e068ec";

var Oracorrect = web3.eth.contract(abi);
Oracorrect.new({data:code,gas:3000000,from:owner}, function(err,oracorrect){
	if(err){
		console.log("ERROR",err);
	}else{
		console.log("--------------------- address -------------------------");
		console.log(oracorrect);
		console.log("-------------------------------------------------------");
	}
	
	
});






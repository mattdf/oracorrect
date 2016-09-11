contract EntitlementRegistry{function get(string _name)constant returns(address );function getOrThrow(string _name)constant returns(address );}
contract Entitlement{function isEntitled(address _address)constant returns(bool );}

import "OracleInterface.sol";

contract Oracorrect{

  // BlockOne ID bindings

  // The address below is for the Edgware network only
  EntitlementRegistry entitlementRegistry = EntitlementRegistry(0xe5483c010d0f50ac93a341ef5428244c84043b54);

  function getEntitlement() constant returns(address) {
      return entitlementRegistry.getOrThrow("com.tr.oracleyo");
  }

  modifier entitledUsersOnly {
    if (!Entitlement(getEntitlement()).isEntitled(tx.origin)) throw; 
		//TODO not msg.sender but owner of contract as entitlement can not be managed for contract (at least not yet)
		//shoud the owener address be signed or should be the account to be used at stake (provider address just being the contract to gather and receive data from? )
		//for now use tx.origin
    _
  }




  // Start of Oracorrect

	uint nonce;
	struct Provider{
		address account;
		uint truthCoins;
		string apistring;
	}

	Oracle[] public providerList;

	mapping(address => Provider) providers;
	
	uint public totalStaked;
	uint public totalOracles;
	uint public priceEstimate;


	struct Request{
		mapping(address => bool) providersUsed;
		uint numProvidersLeft;
		OracleReceiver user;
		uint[] values;
		address[] availableProviders;
	}
	
	

	mapping(uint => Request) requests;

	function Oracorrect(){
		
	}

/////////////////////////////////  provider facing  ///////////////////////////////////////////
function register(string api, uint newStake) entitledUsersOnly {
		providers[msg.sender] = Provider(msg.sender,newStake, api);
		providerList.push(Oracle(msg.sender));
		totalOracles++;
		totalStaked = totalStaked + newStake;
		// TODO: Deregister
	}
	
	function () entitledUsersOnly{
		// Blank function if anyone sends ether to the contract by mistake. Send it back...
		throw;
	}

	function onData(uint id, uint value){
		var request = requests[id];
		if(!request.providersUsed[msg.sender]){
			throw;
		}
		request.providersUsed[msg.sender] = false;
		request.numProvidersLeft--;
		request.values.push(value);

		if(request.numProvidersLeft == 0){
			uint total = 0;
			uint squaredtotal = 0;
			for(uint i=0;i<request.values.length;i++){
				total+= request.values[i];
				squaredtotal += request.values[i]*request.values[i];
			}
			// find mean
			uint mean = total/request.values.length;
			request.user.onData(id, mean);
			priceEstimate = mean;
			// find std deviation
			uint variance = squaredtotal - total*total;
			
			// now check if any of the values squared fall outside the 25th and 75th percentile limits (0.675 s.d.)
			for(uint; i<request.values.length;i++){
				uint diff = mean*mean - request.values[i]*request.values[i]; 
				if(1000*1000*diff*diff > 675*675*variance*variance){
					// value was an outlier
					address penalised = request.availableProviders[i];
				}
				else{
					address payOut = request.availableProviders[i];
					// payOut.send(oracleFee);
				}

				
			}


			
			
		}


	}

	/////////////////////////////////  user facing  ///////////////////////////////////////////
	function query(uint stake){  
		// charge a fee (basically require some ether to call this function)
		uint feeCost = totalStaked/1000000;

		if (msg.value < feeCost) throw;
	
		nonce++;
		mapping(address => bool) providersUsed;
		uint numProviders = 0;
		
		// These are the kind of things used for apistring:
		
		//string poloniexTradestring = currency2+'_'+currency1;
		//string rockTradestring
		//string bitfinexTradestring
		//string yunbiTradestring
		//string krakenTradestring
		
		//"json(https://www.therocktrading.com/api/ticker/"+BTCEUR+").result.0.last"
		//"json(https://poloniex.com/public?command=returnTicker)."+poloniexTradestring+".last"
		//"json(api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.c.0"
		//"json(https://api.bitfinex.com/v1/pubticker/"+bitfinexTradestring+".last_price")
		
		// set it so that each provider is associated with a different 
		requests[nonce].user = OracleReceiver(msg.sender);
		for(uint i = 0; i < providerList.length; i++){
			var providerAddress = providerList[i];
			requests[nonce].providersUsed[providerAddress] = true;
			//TODO pass fee (msg.value)
			providerAddress.query(nonce,providers[providerAddress].apistring);
			requests[nonce].numProvidersLeft ++;
			requests[nonce].availableProviders.push(providerAddress);
		}
		
		
	}

}

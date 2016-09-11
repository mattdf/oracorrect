contract EntitlementRegistry{function get(string _name)constant returns(address );function getOrThrow(string _name)constant returns(address );}
contract Entitlement{function isEntitled(address _address)constant returns(bool );}

contract Oracorrect{

  // BlockOne ID bindings

  // The address below is for the Edgware network only
  EntitlementRegistry entitlementRegistry = EntitlementRegistry(0xe5483c010d0f50ac93a341ef5428244c84043b54);

  function getEntitlement() constant returns(address) {
      return entitlementRegistry.getOrThrow("com.tr.oracleyo");
  }

  modifier entitledUsersOnly {
    if (!Entitlement(getEntitlement()).isEntitled(msg.sender)) throw; 
		//TODO not msg.sender but owner of contract as entitlement can not be managed for contract (at least not yet)
		//shoud the owener address be signed or should be the account to be used at stake (provider address just being the contract to gather and receive data from? )
    _;
  }

  // Start of Oracorrect

	uint nonce;
	struct Provider{
		address account;
		uint truthCoins;
		string apistring;
	}

	public address[] providerList;

	mapping(address => Provider) providers;
	
	public uint totalStaked;
	public uint totalOracles;
	public uint priceEstimate;

	struct Request{
		mapping(address => bool)  providersUsed;
		uint numProvidersLeft;
		address user;
		[]uint values;
	}

	mapping(uint => Request) requests;

	public function Oracorrect(){
		
	}

/////////////////////////////////  provider facing  ///////////////////////////////////////////
public function register(string api, uint newStake) entitledUsersOnly{
		providers[msg.sender] = {account:msg.sender,truthCoins:newStake, apistring: api};
		providerList.push(msg.sender);
		totalOracles++;
		totalStaked = totalStaked + newStake;
		// TODO: Deregister
	}
	
	function () entitledUsersOnly{
		// Blank function if anyone sends ether to the contract by mistake. Send it back...
		throw;
	}

	public function onData(uint id, uint value){
		var request = requests[id];
		if(!request.providers[msg.value]){
			throw;
		}
		request.providers[msg.value] = false;
		request.numProvidersLeft--;
		request.values.push(value);

		if(request.numProvidersLeft == 0){
			uint total = 0;
			for(uint i=0;i<request.values;i++){
				total+= request.values[i];
			}
			request.user.onData(id, total/request.values.length);
		}
		// now look for mean and std dev of priceEstimate

		// reject outliers

		// pay out to correct who had enough stake and penalise outliers
	}

	/////////////////////////////////  user facing  ///////////////////////////////////////////
	public function query(uint stake){  
		// charge a fee (basically require some ether to call this function)
		uint feeCost = totalStaked/1000000;

		if (msg.value < feeCost) throw;
	
		nonce++;
		mapping(address => bool) providersUsed;
		uint numProviders = 0;
		uint[] priceEstimates;

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
		
		
		for(uint i = 0; i < providerList.length; i++){
			var providerAddress = providerList[i];
			providersUsed[providerAddress] = true;
			//TODO pass fee (msg.value)
			providerAddress.query(nonce,providers[providerAddress].apistring);
			numProviders ++;
		}
		
		requests[nonce] = {
			providersUsed : providersUsed,
			numProviders : numProviders,
			user :msg.sender
		};
		
	}

}

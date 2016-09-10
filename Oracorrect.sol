contract EntitlementRegistry{function get(string _name)constant returns(address );function getOrThrow(string _name)constant returns(address );}
contract Entitlement{function isEntitled(address _address)constant returns(bool );}

import "oraclizeapi.sol";

contract Oracorrect is usingOraclize {

  // BlockOne ID bindings

  // The address below is for the Edgware network only
  EntitlementRegistry entitlementRegistry = EntitlementRegistry(0xe5483c010d0f50ac93a341ef5428244c84043b54);

  function getEntitlement() constant returns(address) {
      return entitlementRegistry.getOrThrow("com.tr.oracleyo");
  }

  modifier entitledUsersOnly {
    if (!Entitlement(getEntitlement()).isEntitled(msg.sender)) throw;
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
		mapping(address => bool) providers;
		uint numProvidersLeft;
		address user;
	}

	mapping(uint => Request) requests;

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

	/////////////////////////////////  user facing  ///////////////////////////////////////////
	public function query(uint stake){  // TODO: Add other currencies
	    // charge a fee (basically require some ether to call this function)
    		uint feeCost = totalStaked/1000000;
    
    		if (msg.value < feeCost) throw;
	
		nonce++;
		mapping(address => bool) providers;
		uint numProviders = 0;
		uint[] priceEstimates;
		
		for(provider in providerList){
			provider.query(nonce,stake);
			providers[provider] = true;
			numProviders ++;
		}
		
		requests[nonce] = {
			providers,
			numProviders,
			msg.sender,
			0
		};
		
		// Call the oracle apis

    	for (uint i; i < numProviders; i++){
    	    // for demo purposes all staked oracles use oraclize to get their various data providers
    	    	priceEstimates[i] = oraclize_query("URL", providers[providerList[i]].apistring);
    	    }
    	    
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
    	    
    	    
    // now look for mean and std dev of priceEstimate
    
    // reject outliers
    
    // pay out to correct who had enough stake and penalise outliers
    
    return priceEstimate;
}
		
		
		
	}
	


	

}

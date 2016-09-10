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

  // Your implementation goes here

	uint nonce;
	struct Provider{
		address account;
		uint truthCoins;
	}
	address[] providerList;

	mapping(address => Provider) providers;

	struct Request{
		mapping(address => bool) providers;
		uint numProvidersLeft;
		address user;
	}

	mapping(uint => Request) requests;

/////////////////////////////////  provider facing  ///////////////////////////////////////////
	public function register(){
		providers[msg.sender] = {account:msg.sender,truthCoins:0};
		//TODO....
	}

	public function onData(uint id, uint value) entitledUsersOnly{
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
			request.user.onData(total/request.values.length);
		}
	}

	/////////////////////////////////  user facing  ///////////////////////////////////////////
	public function query(uint stake, string currency1, string currency2){
		nonce++;
		mapping(address => bool) providers;
		uint numProviders = 0;
		for(provider in providerList){
			// TODO: Also check whether they can provide data about the currency pairs entered
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
	}


	

}

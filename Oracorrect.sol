
class Oracorrect{

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
			request.user.onData(total/request.values.length);
		}
	}

	/////////////////////////////////  user facing  ///////////////////////////////////////////
	public function query(uint stake){
		nonce++;
		mapping(address => bool) providers;
		uint numProviders = 0;
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
	}


	

}
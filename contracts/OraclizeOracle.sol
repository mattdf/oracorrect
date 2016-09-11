import "oraclizeapi.sol";
import "OracleInterface.sol";
import "Oracorrect.sol";

contract OraclizeOracle  is usingOraclize{

	mapping(bytes32 => uint) oraclizeIdToId;
	Oracorrect oracorrect;

	function OraclizeOracle(){
		oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
	}

	function registerWithOracleReceiver(Oracorrect _oracorrect,string api, uint stake){
		oracorrect = _oracorrect;
		oracorrect.register(api,stake);
	}

	function query(uint id, string queryString){

		bytes32 oraclizeId = oraclize_query("URL", queryString); //TODO pass fee (msg.value) ?
		oraclizeIdToId[oraclizeId] = id;
	}

	function __callback(bytes32 myid, string result, bytes proof){
		//TODO check the proof
		uint id = oraclizeIdToId[myid];
		//TODO get value out of string
		oracorrect.onData(id,parseInt(result));
	}
}

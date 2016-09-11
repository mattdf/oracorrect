import "oraclizeapi.sol";
import "OracleInterface.sol";

contract OraclizeOracle  is usingOraclize{

	mapping(bytes32 => uint) oraclizeIdToId;
	OracleReceiver oracleReceiver;

	function OraclizeOracle(OracleReceiver oracleReceiver){
		oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
	}

	function query(uint id, string queryString){

		bytes32 oraclizeId = oraclize_query("URL", queryString); //TODO pass fee (msg.value) ?
		oraclizeIdToId[oraclizeId] = id;
	}

	function __callback(bytes32 myid, string result, bytes proof){
		//TODO check the proof
		uint id = oraclizeIdToId[myid];
		//TODO get value out of string
		oracleReceiver.onData(id,parseInt(result));
	}
}

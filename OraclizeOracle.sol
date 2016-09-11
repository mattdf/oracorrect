import "oraclizeapi.sol";

contract OraclizeOracle  is usingOraclize{

	mapping(bytes32 => uint) oraclizeIdToId;
	OracleReceiver oracleReceiver;

	public function OraclizeOracle(OracleReceiver oracleReceiver){
		oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
	}

	public function query(uint id, string queryString){

		bytes32 oraclizeId = oraclize_query("URL", queryString); //TODO pass fee (msg.value) ?
		oraclizeIdToId[oraclizeId] = id;
	}

	public function __callback(bytes32 myid, string result, bytes proof){
		//TODO check the proof
		uint id = oraclizeIdToId[myid];
		//TODO get value out of string
		oracleReceiver.onData(id,value);
	}
}
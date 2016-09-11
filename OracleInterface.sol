contract OracleReceiver{
	function onData(uint id, uint value);
}

contract Oracle{
	function query(uint id, string queryString);
}

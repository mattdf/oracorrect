var solc = require('solc');
var fs = require('fs');


fs.readdir("contracts", function(err, filenames) {
	if(err){
		console.error(err);
		return;
	}
	var input = {}
	for (var i =0; i < filenames.length; i++) {
		var file = filenames[i];
		console.log("adding " + file + " ...");
		input[file] = fs.readFileSync('contracts/' + file).toString();
	}

	console.log("compiling ...");
	var output = solc.compile({sources: input}, 1);

	console.log(output);

	var output_filename = "compiled_contracts.json";
	console.log("writing to " + output_filename + " ...");
	fs.writeFileSync(output_filename, JSON.stringify(output.contracts)); 

});


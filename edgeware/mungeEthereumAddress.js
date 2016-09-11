#!/usr/bin/env node

// this script is used so we know which host mined a block

function translate(x) {
	var map = {
        'g': '8',
        'h': '4',
        'i': '1',
        'j': 'j',
        'k': 'c',
        'l': '1',
        'm': '3',
        'n': 'c',
        'o': '0',
        'p': 'b',
        'q': 'd',
        'r': 'f',
        's': '5',
        't': '7',
        'u': 'c',
        'v': '7',
        'w': '3',
        'x': '8',
        'y': '4',
        'z': '2',
        '/': '7'
    };
	return x.replace(/./g, function (m) {
		if (map[m])
		    return map[m];
		else {
			if (!m.match(/^[0-9a-f]$/)) {
                return 'c';
			}
			return m;
		}
	});
}

console.log('0x'+translate(process.argv[2]).substr(0,40));

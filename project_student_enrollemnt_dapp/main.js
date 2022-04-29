window.addEventListener('load', async () => {
	// set the provider you want from Web3.providers
	web3 = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:8545"));
	console.log('using web3 provider');

	const accounts = await web3.eth.getAccounts();
	web3.eth.defaultAccount = accounts[0];
	console.log('Set the default account: ', accounts[0]);

	var StudentABI = [
			{
				"constant": false,
				"inputs": [
					{
						"name": "fname",
						"type": "string"
					},
					{
						"name": "lname",
						"type": "string"
					},
					{
						"name": "dob",
						"type": "string"
					}
				],
				"name": "setStudent",
				"outputs": [],
				"payable": false,
				"stateMutability": "nonpayable",
				"type": "function"
			},
			{
				"constant": true,
				"inputs": [],
				"name": "getStudent",
				"outputs": [
					{
						"name": "",
						"type": "string"
					},
					{
						"name": "",
						"type": "string"
					},
					{
						"name": "",
						"type": "string"
					}
				],
				"payable": false,
				"stateMutability": "view",
				"type": "function"
			}
	];
	
	StudentDetails = new web3.eth.Contract(StudentABI, '0xbf8ff36b51c077a044669c3e1c947664807252f1');

	refresh();
});

function refresh() {
    StudentDetails.methods.getStudent().call((error, result) => {
        if (!error) {
            $("#instructor").html(
                'Enrolled ' + result[0] + ' ' + result[1] + ' with DOB ' + result[2]);
            console.log(result);
        } else {
            console.log(error);
        }
    });
}

function Update() {
	StudentDetails.methods.setStudent($("#fname").val(), $("#lname").val(), $("#dob").val())
	.send({from: web3.eth.defaultAccount}, (error, transactionHash) => {
		if (!error) {
			console.log(transactionHash);
		} else {
			console.log(error);
		}
	});
}


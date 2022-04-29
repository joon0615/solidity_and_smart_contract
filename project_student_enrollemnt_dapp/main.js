window.addEventListener('load', async () => {
	// set the provider you want from Web3.providers

	// web3.js library uses RPC calls to connect blockchain node and javascript.
	// before we use the code, we should give the input address.
	// we use ganache CLI for Dapp development. 
	// Ganache CLI is personal blockchain for ETH development. 

	// For Ganache Installation, npm and node should be installed first. 
	// After Ganache Installation, type `ganache-cli` to run
	// Ganache will print the available account addresses, private keys, and "port to listen"
	// The input of web3 below is the {Your IP Address}:{Port by Ganache}

	// After running Ganache, Write contract with RemixIDE
	// Set Remix IDE run > environment to `Web3 Provider` with the endpoint of `http://127.0.0.1:8545` same with the input. 
	// When you deploy the contract with Remix, Ganache will print out the tx log. 

	// [ Creating web3 instance ]
	// ex -1 
	// web3 = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:8545"));
	// ex-2 : Change to erbsocket provider for implementing event for logging
	web3 = new Web3(new Web3.providers.WebsocketProvider("http://127.0.0.1:8545"));
	console.log('using web3 provider');

	// [ Getting Account Data and Set Default Account ]
	const accounts = await web3.eth.getAccounts();
	web3.eth.defaultAccount = accounts[0];
	console.log('Set the default account: ', accounts[0]);

	// [ Setting ABI, Application Binary Interface for Contract Instance ]
	// Get ABI value from Remix Editor. Copy and Paste like the example suggested below. 
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
				// this part is added by implementing event for logging
				"anonymous": false,
				"inputs": [
					{
						"name": "from",
						"type": "address"
					},
					{
						"name": "fName",
						"type": "string"
					},
					{
						"name": "lNmae",
						"type": "string"
					},
					{
						"name": "bDate",
						"type": "string"
					}
				],
				"name": "Added",
				"type": "event"
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
	
	// [ Creating Contract ]
	// using .Contract as the constructor
	// pass ABI and address(from Ganache) for the input
	// Web3.js makes a connection based on these parameters
	StudentDetails = new web3.eth.Contract(StudentABI, '0xbf8ff36b51c077a044669c3e1c947664807252f1');

	// Implementing Event and change the displayed value automatically
	// function(error, event) registers a callback to the event object
	StudentDetails.events.Added({}, function(error, event) {
		if(!error) {
			refresh();
		}
		else {
			console.log(error);
		}
	});

	// Get Past Events for the contract
	// 19th Block to the latest Block
	StudentDetails.getPastEvents('Added', {fromBlock: 19, toBlock: 'latest'},
		// can put filter here
		// {fromBlock: 19, toBlock: 'latest', filter: {from: 'put_address_here'}, }, 
		function(error, events) {
			if(!error) {
				events.forEach(event => console.log(event.returnValues));
			}
			else {
				console.log(error);
			}
		}
	)

	refresh();
});

function refresh() {
	// using call method to call method in contract, since getStudent method is view method (No change in state)
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
	// making tx object and change state of the contract
	StudentDetails.methods.setStudent($("#fname").val(), $("#lname").val(), $("#dob").val())
	.send({from: web3.eth.defaultAccount}, (error, transactionHash) => {
		if (!error) {
			console.log(transactionHash);
		} else {
			console.log(error);
		}
	});
}


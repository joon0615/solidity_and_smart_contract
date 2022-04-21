pragma solidity >=0.4.0 <0.7.0;

contract SimpleLottery {
    // this contract should be run in testnet, not local Javascript VM due to usage of blockhash

    uint ticketingPeriodCloses;
    address[] public tickets;
    address public winner;

    constructor(uint duration) public {
        // Submitting Ticket starts from 'now', indicating the current block timestamp
        ticketingPeriodCloses = now + duration * 1 days;
    }

    function buy() public payable {
        require(msg.value >= 0.001 ether);
        require(now < ticketingPeriodCloses);
        tickets.push(msg.sender);
    }

    function () external payable {
        buy();
    }

    function drawWinner() public {
        // requires ticketing window to be closed for at least 5 mins. participants cannot know the block number for the winner. 
        require(now > ticketingPeriodCloses + 5 minutes);
        // winner is empty
        require(winner == address(0));

        // eth does not provide library for random number since the result of evm should be same even nodes are diff
        // use blockhash as an alternative
        // -1 since we cannot know the current block's hash

        // blockhash based random number generation can have side effects
        // miners can manipulate the block hash value 
        bytes32 hash = blockhash(block.number - 1);
        bytes32 rand = keccak256(abi.encode(hash));

        winner = tickets[uint(rand) % tickets.length];
    }

    
    function withdraw() public {
        // withdraw should be in separate function since transferring should be managed carefully
        require(msg.sender == winner);
        msg.sender.transfer(address(this).balance);
    }
}
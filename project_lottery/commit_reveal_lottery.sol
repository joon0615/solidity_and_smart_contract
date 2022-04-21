pragma solidity >=0.4.0 <0.7.0;

contract CommitRevealLottery {
    // This lottery uses random numbers submitted by participants of the lottery
    // It can prevent the side effects of using blockhash for random number generation
    // We use commit-reveal technique to hide the random number value submitted till the ticketing period closes

    uint public ticketingPeriodCloses;
    uint public revealPeriodCloses;

    address[] public tickets;
    address public winner;

    // seed = where random numberis saved after revealing process for drawing winner
    // commitments = where participants' addresses and random number hashes are stacked
    bytes32 seed;
    mapping (address => bytes32) public commitments;

    constructor(uint ticketDuration, uint revealDuration) public {
        // Submitting Ticket starts from 'now', indicating the current block timestamp
        ticketingPeriodCloses = now + ticketDuration * 1 days;
        revealPeriodCloses = ticketingPeriodCloses + revealDuration * 1 days;
    }

    function buy(bytes32 commitment_hash) public payable {
        require(msg.value >= 0.001 ether);
        require(now < ticketingPeriodCloses);

        // tickets.push(msg.sender);
        commitments[msg.sender] = commitment_hash;
    }

    // function () external payable {
    //     buy();
    // }


    function reveal(uint rand) public {
        // When the revealing period starts, each participants should reveal their number 
        // Then we compare the hash of the input number and commitment_hash already submitted
        // If the comparison result was true, submission is finally processed and the ticket is logged

        require (now >= ticketingPeriodCloses);
        require (now <= revealPeriodCloses);

        bytes32 hash_from_input_rand = keccak256(abi.encode(msg.sender, rand));
        require (hash_from_input_rand == commitments[msg.sender]);

        seed = keccak256(abi.encode(seed, rand));
        tickets.push(msg.sender);
    }


    function drawWinner() public {
        // requires ticketing window to be closed for at least 5 mins. participants cannot know the block number for the winner. 
        require(now > ticketingPeriodCloses + 5 minutes);
        // winner is empty
        require(winner == address(0));

        winner = tickets[uint(seed) % tickets.length];
    }

    
    function withdraw() public {
        // withdraw should be in separate function since transferring should be managed carefully
        require(msg.sender == winner);
        msg.sender.transfer(address(this).balance);
    }
}
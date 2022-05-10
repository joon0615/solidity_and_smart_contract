pragma solidity >=0.4.0 <0.8.0;

contract Lottery {
    address public manager;
    address[] public players;
    address payable public winner;
    uint public price = 0.1 ether;

    // no need to write visibility(ex. public)
    constructor() {
        manager = msg.sender;
    }

    function enter() public payable {
        require(msg.value >= price);
        players.push(msg.sender);
    }

    function pickWinner() public {
        require(msg.sender == manager);

        // pick winner
        // use payable keyword to change the type
        // randomized pick by getting residue of random number divided by player list length
        winner = payable(players[_random() % players.length]);

        // send prize
        winner.transfer(address(this).balance);

        // initialize players list
        players = new address[](0);
    }

    function _random() private view returns (uint) {
        // get hash based on block difficulty, time stamp, players info
        // Caution: miners can affect the block info.
        return uint(keccak256(
            abi.encodePacked(block.difficulty, block.timestamp, players)
        ));
    }

    function getPlayers() public view returns(uint) {
        return players.length;
    }
}

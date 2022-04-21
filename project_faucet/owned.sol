pragma solidity ^0.4.24;

// base contract setting owner and provides modifier

contract Owned {
    address owner;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require (msg.sender == owner);
        _;
    }
}
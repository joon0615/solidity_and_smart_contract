pragma solidity ^0.4.24;

import "./mortal.sol";

contract Faucet is Mortal {

    function withdraw(uint withdraw_amount) public {
        // withdraw amount limit
        require(withdraw_amount <= 0.1 ether);

        // sending the withdraw amount to the address requested
        msg.sender.transfer(withdraw_amount);
        emit Withdrawal(msg.sender, withdraw_amount);
    }

    function() public payable {
        // fallback function accepting incomings
        emit Deposit(msg.sender, msg.value);
    }

    event Withdrawal(address indexed to, uint amount);
    event Deposit(address indexed from, uint amount);
}
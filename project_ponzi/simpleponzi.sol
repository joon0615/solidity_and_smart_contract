pragma solidity >=0.4.0 <0.7.0;

contract SimplePonzi {
    // state variables
    address public currentInvestor;
    uint public currentInvestmentAmount = 0;

    function () external payable {
        // new investments must be 10% greater than the current
        uint minimumInvestmentAmount = currentInvestmentAmount * 11 / 10;
        require(msg.value > minimumInvestmentAmount);

        // log investment records
        address previousInvestor = currentInvestor;
        currentInvestor = msg.sender;
        currentInvestmentAmount = msg.value;

        // send previous investor returns
        // Transfer has return values and rollback if error occurs. However, send returns false and continues even error occurs. 
        previousInvestor.transfer(msg.value); 
    }
}
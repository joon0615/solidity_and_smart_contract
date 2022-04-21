pragma solidity ^0.4.24;

// provides self destruction function

import "./owned.sol";

contract Mortal is Owned {
    function destroy() public onlyOwner payable {
        selfdestruct(owner);
    }
}
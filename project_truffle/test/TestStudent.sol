pragma solidity >=0.4.0 <0.8.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Student.sol";

contract TestStudent {
    function testInitialState() public {
        Student student = Student(DeployedAddresses.Student());

        (string memory fname, string memory lname, string memory dob) = student.getStudent();

        Assert.equal(fname, "", "first name should be empty");
        Assert.equal(lname, "", "last name should be empty");
        Assert.equal(dob, "", "dob should be empty");
    }
}


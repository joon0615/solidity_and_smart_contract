// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Student {
    string firstName;
    string lastName;
    string dateOfBirth;

    function setStudent(string memory fname,
                        string memory lname,
                        string memory dob) public {
        firstName = fname;
        lastName = lname;
        dateOfBirth = dob;

        emit Added(msg.sender, fname, lname, dob);
    }

    function getStudent() public view
        returns (string memory, string memory, string memory) {
            return (firstName, lastName, dateOfBirth);
    }

    event Added(address indexed from, string fname, string lname, string bob);
}
pragma solidity >=0.4.22 <0.8.0;

contract Student {
    string firstName;
    string lastName;
    string birthDate;

    function setStudent (
        string memory fName, 
        string memory lName, 
        string memory bDate
    ) public {
        firstName = fName;
        lastName = lName;
        birthDate = bDate;
    }

    function getStudent () public view returns (
        string memory, string memory, string memory
    ) {
        return (firstName, lastName. birthDate);
    }

}
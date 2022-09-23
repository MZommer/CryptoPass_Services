pragma solidity ^0.8.0;


contract StoreValue{
    mapping (address => uint) value_stored;

    function updateMyValue(uint value) public{
        value_stored[msg.sender] = value;
    }

    function retrieveValue(address owner) public view returns (uint) {
        return value_stored[owner];
    }
}

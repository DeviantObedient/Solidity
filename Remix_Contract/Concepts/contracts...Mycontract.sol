//SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.0;

contract Property {

    int public price;
    string public location;
    address public owner;

    constructor(int _price, string memory _location){
        price = _price;
        location= _location;
        owner = msg.sender;
    }

    function setPrice (int _price) public{
        price=_price;
    }

    function getPrice() public view returns(int){
        return price;
    }

    function setLocation(string memory _location) public {
        location=_location;
    }
}
//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract Property{
    //declaring state variables saved in contract storage
    uint public price;//is private by default
    string public location;//declared as public

    //Immutable variables can be initialized at declaration or in the constructor only
    address immutable public owner;

    //Declaring a constant
    int constant area=100;

    /*declaring the constructor
    is executed only once at contract's deployment
    */
    constructor(uint _price, string memory _location){
        price = _price;
        location = _location;
        owner =msg.sender;//initializing owner to the account's address that deploys the contract.
    }

    //getter function, returns a state variable
    //a function declared 'view' does not alter the blockchain
    function getPrice() public view returns(uint){
        return price;
    }

    //setter function, set a state variable
    function setPrice(uint _price) public{
        int a;//local variable saved on stack
        a=10;
        price = _price;
    }
    function setLocation(string memory _location) public {//string type must be declared memory or storage
        location= _location;
    }


}
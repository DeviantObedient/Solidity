//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract Auction{
    //declaring a variable of type mapping
    //Keys are of type address and value of type uint
    mapping(address => uint) public bids;

    //initializing the mapping variable
    //the key is the address of the account that calls the function
    //and the value is the amount of Wei sent when calling the function
    function bid() payable public{
        bids[msg.sender]= msg.value;
    }

}
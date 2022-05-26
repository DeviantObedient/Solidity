//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract GlobalVariables{
    
    /*BLocks global variables*/
    //the current time as a timestamp (seconds from 01 Jan 1970)
    uint public this_moment = block.timestamp;//'now' is deprecated and is an alias to block.timestamp
    //the current block number
    uint public block_number = block.number;
    //the current block difficulty
    uint public difficulty = block.difficulty;
    //the block gas limit (remember that ETH has a block gas limit rather than a block size limit like Bitcoin)
    uint public gas_limit = block.gaslimit;
    
    address public owner;
    uint public sentValue;

    constructor (){
        //msg.sender is the address that interacts with the contracts
        //(deploys it in this case)
        owner = msg.sender;
    }

    function changeOwner() public {
        //msg.sender is the address that interacts with the contracts
        //(calls it in this case)
        owner = msg.sender;
    }

    function sentEther() public payable{//must be payable to receive ETH with the transaction
        //msg.value is the value of wei sent in this transaction (when calling the function)
        sentValue = msg.value;
    }
    //returning the balance of the contract
    function getBalance() public view returns(uint){
        return address(this).balance;
    }

    // function to measure how much gas is spent during an operation
    function howMuchGas() public view returns(uint){
        uint start = gasleft();
        uint j=1;

        for(uint i=1;i<20;i++){
            j+= i;
        }

        uint end = gasleft();

        return start-end;
    }
}
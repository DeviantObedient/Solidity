//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract BytesAndString{

    //Note that byte and string are reference types and not value types.
    bytes public b1='abc';
    string public s1='abc';

    function addElement() public{
        b1.push('x');
        //s1.puch('x');
    }

    function getElement(uint i) public view returns(bytes1){
        return b1[i]; 
    }

    function getLength() public view returns(uint){
        return b1.length;
    }


}
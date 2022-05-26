//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract FixedSizeArrays {
    //declaring a fixed-size array of type uint with 3 elements
    uint[3] public numbers = [2,3,4];

    //declaring fixed-sized arrays of type bytes
    bytes1 public b1;
    bytes2 public b2;
    bytes3 public b3;
    //... up to bytes32

    //Setter to change an element at a fixed index
    function setElement(uint _index, uint _value) public{
        numbers[_index]=_value;
    }

    //setting bytes arrays
    function setBytesArrays() public{
        b1='a';
        b2='ab';
        b3='abc';
        // b3[0] = 'a'; // ERROR => can not change individual bytes
 
// byte is an alias for bytes1 on older code


    }

}
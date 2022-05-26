//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract StorageVsMemory{

    string[] public cities = ['Prague','Berlin'];

    //The memory function will not touch the state variable cities[] when working on memory
    function f_memory() view public {
        string[] memory s1 = cities;
        s1[0]='Paris';
    }

    //The storage function will change the state variable cities[]
    //cause S1 is a reference to the same memory location where the state variable was saved
    //and changing it also changes the state variable.
    function f_storage() public {
        string[] storage s1 = cities;
        s1[0]='Paris';
    }
}

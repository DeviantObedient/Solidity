//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract DynamicArrays{
    //Dynamic array of type uint
    uint[] public numbers;

    //Getter function to get length of the array
    function getLength() public view returns(uint){
        return numbers.length;
    }

    //Add a new element to the array with push()
    function addElement(uint _item) public {
        numbers.push( _item);
    }
    //removing the last element of the array
    function removeElement() public{
        numbers.pop();
    }

    //Returning an element at an index
    function getElement(uint _index) public view returns(uint){
        if(_index<numbers.length){
            return numbers[_index];
        }else return 0;
    }

    function memoryArray() public {
        //declaring a memory dynamic array
        //It is not possible to resize a memory arrays, so push() and pop() will not work.

        uint[] memory dynamicMemoryArray = new uint[](3);
        dynamicMemoryArray[0]=10;
        dynamicMemoryArray[1]=12;
        dynamicMemoryArray[2]=14;
        numbers=dynamicMemoryArray;

    }


}
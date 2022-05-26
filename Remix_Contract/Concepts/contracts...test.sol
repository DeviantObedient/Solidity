
pragma solidity ^0.8.0;

contract FixedArray{
    uint[3] public arraynumber = [1,2,4];

    function setArray(uint _index, uint _value) public {
        arraynumber[_index]= _value;
    }

    function getLength() public view returns(uint){
        return arraynumber.length;
    }
}
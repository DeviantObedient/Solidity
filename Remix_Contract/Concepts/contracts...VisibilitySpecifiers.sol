//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract VisibilitySpecifiers{

    int public x = 10;
    int y=20; //internal by default

    function get_Y() public view returns(int){
        return y;
    }

    function private_func1() private view returns(int){
        return x;
    }

    function public_func1() public view returns(int){
        int a ;
        a= private_func1()+1;
        return a;
    }

    function internal_func1() internal view returns(int){
        return x+2;
    }

    function external_func1() external view returns(int){
        return x+3;
    }

    function public_func2() public pure returns(int){
        int b;
        //b=external_func1(); -> external function can be call only outside of the contract
        // Even though external_func1() wasn’t external it wouldn’t be possible to be called 
        // from within public_func2() because public_func2() is pure (it can not read nor write to the blockchain)
        return b;
    }
}

contract DerivedContract1 is VisibilitySpecifiers{
    int public xx=internal_func1();
    //int public yy=private_func1(); -> private function can't be called from derived contract.
}

contract DeployingContract{
    VisibilitySpecifiers public contract_1 = new VisibilitySpecifiers();
    int public xx= contract_1.external_func1();
}

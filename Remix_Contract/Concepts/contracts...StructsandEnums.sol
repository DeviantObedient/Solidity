//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

//declaring a struct type outside of a contract
//The declared struct can be used in any contract declared in this file

struct Instructor{
    uint age;
    string name;
    address addr;
}

contract Academy{
    //declaring a state variable of type Instructor
    Instructor public academyInstructor;

    //declaring a new enum type
    enum State {Open,Unkown,Closed}

    //declaring and initializing a new state variable of type State
    State public academyState = State.Open;

    //initializing the struct in the constructor
    constructor(uint _age, string memory _name, address _addr) {
        academyInstructor.age = _age;
        academyInstructor.name = _name;
        academyInstructor.addr = _addr;
    }

    //Changing a struct state variable
    function changeInstructor(uint _age, string memory _name, address _addr) public {
        if(academyState == State.Open){

            Instructor memory newInstructor = Instructor({
                age:_age,
                name:_name,
                addr:_addr
            });
            academyInstructor = newInstructor;
        }
    }
}

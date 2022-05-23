pragma solidity ^0.5.0;


contract Adoption {

  //Solidity has a unique type, Adress, which represents ethereum addresses stored as 20 bytes values.
  address[16] public adopters;
  //This is an array of Ethereum address. Arrays contains ONE type of values, and can be of fixed or variables length
  //Public variables have automatic getters method, but in the case of array, a key is necessary and will only return a unique value.

  //First function : Adopting a pet
  function adopt(uint petId) public returns (uint){

    require(petId >= 0 && petId <= 15 );
    adopters[petId]= msg.sender;

    return petId;
  }
  //In solidity, both the types of both the function parameters and output must be specified.
  //In this case, we will take a petId integer in parameter, and return a integer

  //msg.sender represents the address of the person or smart contract calling the function.

  //Second function: Retrieving an adopter
  function getAdopters() public view returns (address[16] memory){
    return adopters;

  }
  //memory in the return type gives the data location for the variables
  //The "view" keyword in the function declaration means that the function will not modify the state of the contract.
}

pragma solidity ^0.5.0;

import "truffle/Assert.sol";
//Assert.sol : Gives us various asertions to use in our test.
//In testing, an assertions tests for things like equality, inequality or emptiness to return a pass/fail from our test.
//more details on the Assert.sol here :https://github.com/trufflesuite/truffle/blob/master/packages/resolver/solidity/Assert.sol

import "truffle/DeployedAddresses.sol";
//DeployedAddresses.sol : when running tests, truffle will deployed a fresh instance of the contract being tested to the blockchain.
//This smart contract gets the address of the deployed contract.

import "../contracts/Adoption.sol";
//Adoption.sol: the contract we want to test.


contract TestAdoption {
  //The address of the adoption contract to be tested
  Adoption adoption=Adoption(DeployedAddresses.Adoption());

  //The id of the pet that we use for testing
  uint expectedPetId = 8;

  // The expected owner of adopted pet is this contract
  address expectedAdopter = address(this);
  //this is a contract wide variable that gets this contract's address.

  //Testing the Adopt() function from the Adoption.sol contracts
  function testUserCanAdoptPet() public {
    uint returnedId = adoption.adopt(expectedPetId);
    Assert.equal(returnedId, expectedPetId, "Adoption of the expected pet should match what is returned");
  }

  //Testing retrieval of a single petowner's address
  function testGetAdopterAddressByPetId() public {
    address adopter = adoption.adopters(expectedPetId);
    Assert.equal(adopter, expectedAdopter, "Owner of the expected Pet should be this contract");
  }

  //Testing retrieval of all pet owners
  function testGetAdopterAddressByPetIdInArray() public {
    //store adopters in memory rather than in contract storage
    address[16] memory adopters = adoption.getAdopters();
    //Note the memory attribute on adopters. The memory attribute tells Solidity to temporarily store the value in memory,
    //rather than saving it to the contract's storage.

    Assert.equal(adopters[expectedPetId],expectedAdopter,"");
    //Since adopters is an array, and we know from the first adoption test that we adopted pet expectedPetId,
    //we compare the testing contracts address with location expectedPetId in the array.

  }

}

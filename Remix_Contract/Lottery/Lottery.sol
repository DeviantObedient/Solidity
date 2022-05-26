//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract Lottery{

    address payable[] public players;//Two types of addresses : Plain and Payable. Only payable address can receive ETH.
    address public manager;

    constructor(){
        manager = msg.sender;
        //Challenge#2:manager automatically added without sending ETH
        players.push(payable(manager));
    }

    receive() external payable{
        //Challenge#1: manager can not participate to the lottery sending ether
        require (msg.sender != manager);
        require (msg.value == 0.1 ether);
        
        players.push(payable(msg.sender));
    }

    /*function transferBalance(address payable _to) public {
        require(manager == msg.sender);
        _to.transfer(getBalance());
    }*/

    function getBalance() public view returns(uint){
        require (manager == msg.sender);
        return address(this).balance;
    }

    function random() public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }
    function selectWinnerForManager() public {
        require (manager == msg.sender);
        require (players.length >=3);
        
        uint r = random();
        address payable winner;
        uint winnerIndex = r % players.length;
        
        winner = players[winnerIndex];
        //Challenge#4 : manager get a 10% fee of the lottery funds
        uint managerFee = (getBalance() * 10)/100;
        uint winnerPrize = (getBalance() * 90)/100;
        payable(manager).transfer(managerFee);
        //transfer the amount to the winner's address
        winner.transfer(winnerPrize);
        //Reset the lottery with a new dynamic array
        players = new address payable[](0);

        //Challenge#2:manager automatically added for the next round
        players.push(payable(manager));
    }
    //Challenge#3 : Anyone can select the winner if there are at least 10 players
    function selectWinnerForAnyone() public {
        require (players.length >=10);
        
        uint r = random();
        address payable winner;
        uint winnerIndex = r % players.length;
        
        winner = players[winnerIndex];
        //transfer the amount to the winner's address
        winner.transfer(getBalance());
        //Reset the lottery with a new dynamic array
        players = new address payable[](0);

        //Challenge#2:manager automatically added for the next round
        players.push(payable(manager));
    }
}

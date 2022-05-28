//SPDX-License-Identifier: No license

pragma solidity ^0.8.0;

contract Auction{

    address payable public owner;
    //DateTime public auctionStart;
    //DateTime public auctionEnd;
    uint public startBlock;
    uint public endBlock;
    string ipfs_hash;
    enum State {Started, Running, Ended, Canceled}
    State public auctionState;

    uint public highestBindingBid;
    address payable public highestBidder;


    mapping(address => uint) public bids;
    uint bidIncrement;


    constructor(address eoa){
        owner = payable(eoa);
        //owner = payable(address(tx.origin));
        auctionState = State.Running;
        startBlock = block.number;
        endBlock = startBlock + 40320; //Approximately one week with a 15 seconds block
        ipfs_hash = "";
        bidIncrement = 100;
    }
    
    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }

    modifier notOwner(){
        require(msg.sender != owner);
        _;
    }

    modifier afterStart(){
        require(block.number >= startBlock);
        _;
    }

    modifier beforeEnd(){
        require(block.number < endBlock);
        _;
    }

    function min(uint a, uint b) pure internal returns(uint){
            if(a <= b){
                return a;
            }else return b;

    }
    function placeBid() public payable notOwner afterStart beforeEnd{ 
        require(auctionState == State.Running);
        require(msg.value >= 100);

        uint currentBid = bids[msg.sender] + msg.value;
        require(currentBid > highestBindingBid);
        bids[msg.sender] = currentBid;

        if(currentBid <= bids[highestBidder]){
            highestBindingBid = min((currentBid + bidIncrement), bids[highestBidder]);
        
        }else{
            highestBindingBid = min(currentBid, (bids[highestBidder] + bidIncrement));
            highestBidder = payable(msg.sender);
        }

    }
    receive() external payable{
    
    }

    fallback() external payable{

    }

    function cancelAuction() public onlyOwner{
        auctionState = State.Canceled;

    }

   function finalizeAuction() public{
       require(auctionState == State.Canceled || block.number > endBlock);
       require(msg.sender == owner || bids[msg.sender] > 0);//Only owner or bidders can access the function

       address payable recipient;
       uint value;

       if(auctionState == State.Canceled){//auction was canceled, and every bidder receive its money back
            recipient = payable(msg.sender);
            value = bids[msg.sender];
       } else {//Auction ended but not canceled
            if(msg.sender == owner){
                recipient = owner;
                value = highestBindingBid;
            }else{//this is a bidder who wants to get his money back after the auction end.
                if(msg.sender == highestBidder){
                    recipient = highestBidder;
                    value = bids[highestBidder] - highestBindingBid;
                }else {// this is neither the owner nor the winner of the auction
                    recipient = payable(msg.sender);
                    value = bids[msg.sender];
                }
            }
       }
       //reset the bidder to zero BEFORE sending money, so he cant claim multiple times or exploit through a fallback function.
       //he is not considered a bidder anymore.
        bids[recipient] = 0;
        //once the recipient balance is reset to 0, send the money.
        recipient.transfer(value);
   }

}

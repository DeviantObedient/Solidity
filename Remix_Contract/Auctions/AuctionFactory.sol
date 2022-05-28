//SPDX-License-Identifier: No license
import "../Auction.sol";

pragma solidity ^0.8.0;

contract AuctionFactory{

    address public auctionFactory;
    Auction[] public auctionList;

    constructor(){
        auctionFactory = msg.sender;
    }

    function createAuction() public {
        Auction newAuction = new Auction(msg.sender);
        auctionList.push(newAuction);

    }
}

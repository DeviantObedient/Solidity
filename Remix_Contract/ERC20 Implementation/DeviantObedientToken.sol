//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;
/*
EIP-20 : ERC-20 Token Standard
https://eips.ethereum.org/EIPS/eip-20
*/

interface ERC20Interface{
    //Mandatory functions
    function totalSupply() external view returns (uint);
    function balanceOf(address tokenOwner) external view returns (uint balance);
    function transfer(address to, uint tokens) external returns (bool succes);
    
    //Functions needed to be fully compliant ERC20
    function allowance(address tokenOwner, address spender) external view returns (uint remaining);
    function approve(address spender, uint tokens) external returns (bool success);
    function transferFrom(address from, address to, uint tokens) external returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);

}

contract DeviantObedientToken is ERC20Interface{
    string public name = "DeviantObedient Token";
    string public symbol = "DOBT";
    uint public decimals = 4;
    uint public override totalSupply;

    address public founder;
    mapping(address => uint) public balances;
    //balances[0X1423...]=100; this is how the contract will keep track of the balances of the token holders

    constructor(){
        totalSupply = 1000000;
        founder = msg.sender;
        balances[founder] = totalSupply;
    }

    function balanceOf(address tokenOwner) public view override returns(uint balance){
        return balances[tokenOwner];
    }
    
    function transfer(address to, uint tokens) public override returns(bool success){
        require(balances[msg.sender] >= tokens);
        
        balances[to] += tokens;
        balances[msg.sender] -= tokens;
        emit Transfer(msg.sender, to, tokens);

        return true;
    }

    mapping(address => mapping(address => uint)) allowed;//for each address, a mapping of addresses allowed to spend token and the ammount allowed

    function allowance(address tokenOwner, address spender) public view override returns (uint remaining){
        //returns the remaining amount of token allowed by the tokenOwner to be spent by the spender
        return allowed[tokenOwner][spender];
    }
    
    function approve(address spender, uint tokens) public override returns (bool success){
        require(balances[msg.sender] >= tokens);
        require(tokens >0);

        allowed[msg.sender][spender] = tokens;

        emit Approval(msg.sender, spender, tokens);
        return true;

    }
    
    function transferFrom(address from, address to, uint tokens) public override returns (bool success){
        //check that msg.sender is allowed to spent enough token
        require(allowed[from][msg.sender] >= tokens);
        //check the balance of the tokenOwner to see if he has enough token to transfer
        require(balances[from] >= tokens);

        //then update the balances from
        balances[from] -= tokens;
        //update the allowance remaining token
        allowed[from][msg.sender] -= tokens;
        //update the balance of the receiver
        balances[to] += tokens;
    
        emit Transfer(from, to, tokens);
        return true;
    }
}

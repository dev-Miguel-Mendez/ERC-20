//SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract Token {

    string public name;
    string public symbol;

    uint public totalSupply; // LEAVE AS 1000000 ether for 1 Million tokens with 18 decs (or any other amount);
    //✨✨ Since we specified 18 decimals, it will get "cut" after 100 ✨✨

    uint public decimals; //✨✨ We want to mimic ethereum which also uses 18 decimals. ✨✨
    
    address creator;
    

    mapping(address => uint) public balanceOf;
    mapping(address => mapping(address => uint)) public allowance;

  

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);

    constructor(string memory _name, string memory _symbol, uint _totalSupply, uint _decimals, address creator){
        
    }





    //✨✨ We need to make this reusable because it is going to be used both by "transfer()" and "transferFrom()"✨✨
    function _transfer(address _from, address to, uint value) internal returns(bool){ 
        require(to != address(0), "ERC20: transfer to the zero address");
        balanceOf[_from] -= value; //✨✨ We don't use "msg.sender" because it will also be used in "transferFrom()"✨✨
        balanceOf[to] += value;
        emit Transfer(_from, to, value);
        return true;
    }

    function transfer(address to, uint value) public returns(bool){
        require(balanceOf[msg.sender] >= value, "Insufficient balance");
        _transfer(msg.sender, to, value);
        return true;
    }


    //✨✨ This function needs to be called by one party (sender)  before the approved party (spender) can call "transferFrom()"✨✨
    function approve(address spender, uint value) public returns (bool) {
        allowance[msg.sender][spender] += value;
        emit Approval(msg.sender, spender, value);

        return true;
    }

                         //✨✨ Here is the logic for approve, _transfer and transfer from✨✨
    //✨✨ When you approve, you still want to be able to use your own tokens.✨✨
    //✨✨ You may approve the highest uint BUT, when using transferFrom it gets validated✨✨
    //✨✨ The transfer from function we subtract only in the allowance mapping , while approve will subtract in balanceOf.✨✨

    function transferFrom(address from, address to, uint value) public returns(bool){
        require(balanceOf[from] >= value, "Insufficient balance from owner");
        require(allowance[from][msg.sender] >= value, "Not enough allowance");

        allowance[from][msg.sender] -= value;
        _transfer(from, to, value);

        return true;
    }



}





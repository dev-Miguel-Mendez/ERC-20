//SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract WETH {

    string public name = "Wrapped Ether";
    string public symbol = "WETH";

    //✨✨ Since we specified 18 decimals, it will get "cut" after 100 ✨✨

    uint256 public decimals = 18; //✨✨ We want to mimic ethereum which also uses 18 decimals. ✨✨
    
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;


    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Deposit(address indexed dst, uint amount);
    event Withdrawal(address indexed src, uint256 amount);
    function deposit() public payable {
        balanceOf[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) public {
        require(balanceOf[msg.sender] >= amount, "Not enough WETH stored");
        balanceOf[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
        emit Withdrawal(msg.sender, amount);
    }


    function _transfer(address _from, address to, uint256 value) internal returns(bool){ 
        require(to != address(0), "ERC20: transfer to the zero address");
        balanceOf[_from] -= value; //✨✨ We don't use "msg.sender" because it will also be used in "transferFrom()"✨✨
        balanceOf[to] += value;
        emit Transfer(_from, to, value);
        return true;
    }

    function transfer(address to, uint256 value) public returns(bool){
        require(balanceOf[msg.sender] >= value, "Insufficient balance");
        _transfer(msg.sender, to, value);
        return true;
    }


    function approve(address spender, uint256 value) public returns (bool) {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);

        return true;
    }

    function transferFrom(address from, address to, uint256 value) public returns(bool){
        require(balanceOf[from] >= value, "Insufficient balance from owner");
        require(allowance[from][msg.sender] >= value, "Not enough allowance");

        allowance[from][msg.sender] -= value;
        _transfer(from, to, value);

        return true;
    }
}





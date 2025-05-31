//SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract Token {

    mapping(address => uint256) private s_balances;
    mapping(address => mapping(address => uint256)) public _allowance;

    constructor(){
        s_balances[msg.sender] = totalSupply();
    }   

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    

    function name() public pure returns (string memory){
        return "Lily";
    }
    function symbol() public pure returns (string memory){
        return "LY";
    }
    //✨✨ Same as "string public name = "ManualToken";"✨✨

    function totalSupply() public pure returns (uint256){
        //✨✨ We will start with 100 (a hundred) tokens✨✨
        return 100 ether; //✨✨ This should be 100 * 10^18 (100 000000000000000000)✨✨
        //✨✨ Since we specified 18 decimals, it will get "cut" after 100 ✨✨
    }

    function decimals() public pure returns (uint8){
        //✨✨ We want to mimic ethereum which also uses 18 decimals. ✨✨
        return 18;
    }

    function balanceOf (address _owner) public view returns (uint256) {
        return s_balances[_owner];
    }




    //✨✨ We need to make this reusable because it is going to be used both by "transfer()" and "transferFrom()"✨✨
    function _transfer(address _from, address to, uint256 value) public returns(bool){ 
        require(to != address(0), "ERC20: transfer to the zero address");
        s_balances[_from] -= value; //✨✨ We don't use "msg.sender" because it will also be used in "transferFrom()"✨✨
        s_balances[to] += value;
        emit Transfer(_from, to, value);
        return true;
    }

    function transfer(address to, uint256 value) public {
        require(balanceOf(msg.sender) >= value, "Insufficient balance");
        _transfer(msg.sender, to, value);
    }


    //✨✨ This function needs to be called by one party (sender)  before the approved party (spender) can call "transferFrom()"✨✨
    function approve(address spender, uint256 value) public returns (bool) {
        _allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);

        return true;
    }

                         //✨✨ Here is the logic for approve, _transfer and transfer from✨✨
    //✨✨ When you approve, you still want to be able to use your own tokens.✨✨
    //✨✨ You may approve the highest uint256 BUT, when using transferFrom it gets validated✨✨
    //✨✨ The transfer from function we subtract only in the _allowance mapping , while approve will subtract in s_balances.✨✨

    function transferFrom(address from, address to, uint256 value) public {
        require(balanceOf(from) >= value, "Insufficient balance from owner");
        require(_allowance[from][msg.sender] >= value, "Not enough _allowance");

        _allowance[from][msg.sender] -= value;
        _transfer(from, to, value);
    }
}
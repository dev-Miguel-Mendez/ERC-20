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

    constructor(string memory _name, string memory _symbol, uint _totalSupply, uint _decimals, address _creator){
        name = _name;
        symbol = _symbol;
        // totalSupply = _totalSupply; //✨✨ We call this in _mint()✨✨
        decimals = _decimals;
        creator = _creator; //⚠️⚠️ We need to pass the "creator" here because this can be call from a factory ⚠️⚠️
        _mint(_creator, _totalSupply);
    }   

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);


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
        //⚠️⚠️ NEED TO DO += ⚠️⚠️
        //⚠️⚠️ NEED TO DO += ⚠️⚠️
        //⚠️⚠️ NEED TO DO += ⚠️⚠️
        //⚠️⚠️ NEED TO DO += ⚠️⚠️
        //⚠️⚠️ NEED TO DO += ⚠️⚠️
        //⚠️⚠️ NEED TO DO += ⚠️⚠️
        //⚠️⚠️ NEED TO DO += ⚠️⚠️
        //⚠️⚠️ NEED TO DO += ⚠️⚠️
        //⚠️⚠️ NEED TO DO += ⚠️⚠️
        //⚠️⚠️ NEED TO DO += ⚠️⚠️
        //⚠️⚠️ NEED TO DO += ⚠️⚠️
        //⚠️⚠️ NEED TO DO += ⚠️⚠️
        allowance[msg.sender][spender] = value;
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

    function mint(address to, uint amount) public{
        require(msg.sender == creator, "Only the creator can call this function");
        _mint(to, amount);
    }
    
    //🟠🟠 Why is there "_mint" and "mint"? 🟠🟠
    //The difference is that "_mint" is an internal function, while "mint" is a public function.
    // _mint assumes you know what you're doing, so it skips checks like authorization or validation, use it in the constructor, tests or other internal code.
        
    function _mint(address to, uint amount) internal { //✨✨ This doesn't check if the sender is the owner because we only call it from the constructor or in the mint function.✨✨
        require(to != address(0), "Cannot mint to zero address");
        totalSupply += amount;
        balanceOf[to] = amount;
        emit Transfer(address(0), to, amount);

    }   


}





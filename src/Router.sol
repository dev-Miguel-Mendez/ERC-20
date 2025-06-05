// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transferFrom(address from, address to, uint amount) external returns (bool);
    function transfer(address to, uint amount) external returns (bool);
    function approve(address spender, uint amount) external returns (bool);
    function balanceOf(address account) external view returns (uint);
}

interface IWETH is IERC20 {
    function deposit() external payable;
    function withdraw(uint) external;
}

interface IPair {
    function mint(address to) external returns (uint liquidity);
}


contract Router {
    address public immutable WETH_ADDRESS;

    constructor(address _weth){
        WETH_ADDRESS = _weth;
    }


    //✨✨ In Uniswap there are two functions to add a liquidity. This one of them and the other one takes 2 ERC20 tokens.✨✨
    //✨✨ They both will use the same "mint()" function  in the pair contract.✨✨
    function addLiquidityEth(address token, address pair, uint tokenAmount) external payable  {
        //✨✨ This first needs permission.✨✨
        bool success = IERC20(token).transferFrom(msg.sender, pair, tokenAmount); //✨✨This will be the reserve0✨✨
        require(success, "transferFrom failed");
        IWETH(WETH_ADDRESS).deposit{value: msg.value}();
        IWETH(WETH_ADDRESS).transfer(pair, msg.value);


        IPair(pair).mint(msg.sender);
    }
}
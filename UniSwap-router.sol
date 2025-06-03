

//⚠️⚠️ In Uniswap V2, adding liquidity via the router involves two functions, depending on whether you're adding to a token-token pair or a token-ETH pair: ⚠️⚠️

//⚠️⚠️ In Uniswap V2, adding liquidity via the router involves two functions, depending on whether you're adding to a token-token pair or a token-ETH pair: ⚠️⚠️



//⚠️⚠️ In Uniswap V2, adding liquidity via the router involves two functions, depending on whether you're adding to a token-token pair or a token-ETH pair: ⚠️⚠️



//⚠️⚠️ In Uniswap V2, adding liquidity via the router involves two functions, depending on whether you're adding to a token-token pair or a token-ETH pair: ⚠️⚠️



//⚠️⚠️ In Uniswap V2, adding liquidity via the router involves two functions, depending on whether you're adding to a token-token pair or a token-ETH pair: ⚠️⚠️



//⚠️⚠️ In Uniswap V2, adding liquidity via the router involves two functions, depending on whether you're adding to a token-token pair or a token-ETH pair: ⚠️⚠️



//⚠️⚠️ In Uniswap V2, adding liquidity via the router involves two functions, depending on whether you're adding to a token-token pair or a token-ETH pair: ⚠️⚠️









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
    function mint(address provider) external returns (uint liquidity);
}



contract BasicRouter {
    address public immutable WETH;
    
    constructor(address _weth) {
        WETH = _weth;
    }
    

    //✨✨ In Uniswap there are two functions to add a liquidity. This one of them and the other one takes 2 ERC20 tokens.✨✨
    //✨✨ They both will use the same "mint()" function  in the pair contract.✨✨
    function addLiquidityETH( address token, address pair, uint tokenAmount) external payable {


        //✨✨ This first needs permission.✨✨
        IERC20(token).transferFrom(msg.sender, pair, tokenAmount);

        IWETH(WETH).deposit{value: msg.value}();
        IWETH(WETH).transfer(pair, msg.value);

        IPair(pair).mint(msg.sender);
    }
}


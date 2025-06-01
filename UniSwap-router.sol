


//⚠️⚠️ Don't focus on this for now, focus on the pair ⚠️⚠️
//⚠️⚠️ Don't focus on this for now, focus on the pair ⚠️⚠️
//⚠️⚠️ Don't focus on this for now, focus on the pair ⚠️⚠️
//⚠️⚠️ Don't focus on this for now, focus on the pair ⚠️⚠️
//⚠️⚠️ Don't focus on this for now, focus on the pair ⚠️⚠️
//⚠️⚠️ Don't focus on this for now, focus on the pair ⚠️⚠️
//⚠️⚠️ Don't focus on this for now, focus on the pair ⚠️⚠️
//⚠️⚠️ Don't focus on this for now, focus on the pair ⚠️⚠️
//⚠️⚠️ Don't focus on this for now, focus on the pair ⚠️⚠️
//⚠️⚠️ Don't focus on this for now, focus on the pair ⚠️⚠️
//⚠️⚠️ Don't focus on this for now, focus on the pair ⚠️⚠️



//⚠️⚠️ Don't focus on this for now, focus on the pair ⚠️⚠️
//⚠️⚠️ Don't focus on this for now, focus on the pair ⚠️⚠️
//⚠️⚠️ Don't focus on this for now, focus on the pair ⚠️⚠️
//⚠️⚠️ Don't focus on this for now, focus on the pair ⚠️⚠️
//⚠️⚠️ Don't focus on this for now, focus on the pair ⚠️⚠️
//⚠️⚠️ Don't focus on this for now, focus on the pair ⚠️⚠️
//⚠️⚠️ Don't focus on this for now, focus on the pair ⚠️⚠️
//⚠️⚠️ Don't focus on this for now, focus on the pair ⚠️⚠️
//⚠️⚠️ Don't focus on this for now, focus on the pair ⚠️⚠️
//⚠️⚠️ Don't focus on this for now, focus on the pair ⚠️⚠️
//⚠️⚠️ Don't focus on this for now, focus on the pair ⚠️⚠️


//⚠️⚠️ Don't focus on this for now, focus on the pair ⚠️⚠️
//⚠️⚠️ Don't focus on this for now, focus on the pair ⚠️⚠️
//⚠️⚠️ Don't focus on this for now, focus on the pair ⚠️⚠️
//⚠️⚠️ Don't focus on this for now, focus on the pair ⚠️⚠️
//⚠️⚠️ Don't focus on this for now, focus on the pair ⚠️⚠️
//⚠️⚠️ Don't focus on this for now, focus on the pair ⚠️⚠️
//⚠️⚠️ Don't focus on this for now, focus on the pair ⚠️⚠️
//⚠️⚠️ Don't focus on this for now, focus on the pair ⚠️⚠️
//⚠️⚠️ Don't focus on this for now, focus on the pair ⚠️⚠️
//⚠️⚠️ Don't focus on this for now, focus on the pair ⚠️⚠️
//⚠️⚠️ Don't focus on this for now, focus on the pair ⚠️⚠️






// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transferFrom(address from, address to, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function approve(address spender, uint value) external returns (bool);
}

interface IWETH is IERC20 {
    function deposit() external payable;
    function withdraw(uint value) external;
}

interface IUniswapPair {
    function addLiquidity(uint amountToken, uint amountWETH, address to) external;
}

interface IUniswapFactory {
    function getPair(address tokenA, address tokenB) external view returns (address);
    function createPair(address tokenA, address tokenB) external returns (address);
}

contract MiniRouter {
    address public immutable WETH;
    address public immutable factory;

    constructor(address _weth, address _factory) {
        WETH = _weth;
        factory = _factory;
    }

    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        address to
    ) external payable {
        require(msg.value > 0, "No ETH sent");

        // Wrap ETH to WETH
        IWETH(WETH).deposit{value: msg.value}();

        // Transfer tokens from user to this contract
        IERC20(token).transferFrom(msg.sender, address(this), amountTokenDesired);

        // Send token and WETH to the pair
        address pair = IUniswapFactory(factory).getPair(token, WETH);
        if (pair == address(0)) {
            pair = IUniswapFactory(factory).createPair(token, WETH);
        }

        IERC20(token).transfer(pair, amountTokenDesired);
        IERC20(WETH).transfer(pair, msg.value);

        // Call custom addLiquidity in the pair (simplified)
        IUniswapPair(pair).addLiquidity(amountTokenDesired, msg.value, to);
    }

    // Needed to receive ETH
    receive() external payable {}
}

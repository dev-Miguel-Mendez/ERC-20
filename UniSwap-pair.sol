




















// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transferFrom(address sender, address to, uint amount) external returns (bool);
    function transfer(address to, uint amount) external returns (bool);
    function balanceOf(address owner) external view returns (uint);
    function approve(address spender, uint amount) external returns (bool);
}

contract MiniSwapPair {
    address public token0;
    address public token1;

    uint public reserve0;
    uint public reserve1;

    constructor(address _token0, address _token1) {
        token0 = _token0;
        token1 = _token1;
    }

    function addLiquidity(uint amount0, uint amount1) external {
        IERC20(token0).transferFrom(msg.sender, address(this), amount0);
        IERC20(token1).transferFrom(msg.sender, address(this), amount1);

        reserve0 += amount0;
        reserve1 += amount1;
    }

    function getAmountOut(uint amountIn, address inputToken) public view returns (uint amountOut) {
        require(amountIn > 0, "Invalid input");
        bool isToken0 = inputToken == token0;
        (uint reserveIn, uint reserveOut) = isToken0 ? (reserve0, reserve1) : (reserve1, reserve0);

        uint amountInWithFee = amountIn * 997;
        uint numerator = amountInWithFee * reserveOut;
        uint denominator = reserveIn * 1000 + amountInWithFee;
        amountOut = numerator / denominator;
    }

    function swap(uint amountIn, address inputToken) external {
        bool isToken0 = inputToken == token0;
        address outputToken = isToken0 ? token1 : token0;

        uint amountOut = getAmountOut(amountIn, inputToken);

        IERC20(inputToken).transferFrom(msg.sender, address(this), amountIn);
        IERC20(outputToken).transfer(msg.sender, amountOut);

        if (isToken0) {
            reserve0 += amountIn;
            reserve1 -= amountOut;
        } else {
            reserve1 += amountIn;
            reserve0 -= amountOut;
        }
    }
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

interface IERC20 {          //✨✨ It doesn't matter if the original function is declared as public.✨✨
    function transferFrom(address sender, address to, uint256 amount ) external returns(bool);
    function transfer(address to, uint256 value) external;
}


contract Pair { 
    address public token0;
    address public token1;

    uint256 public reserve0;
    uint256 public reserve1;

    constructor(address _token0, address _token1){
        token0 = _token0;
        token1 = _token1;
    }

    function addLiquidity(uint256 amount0, uint256 amount1) public {
        IERC20(token0).transferFrom(msg.sender, address(this), amount0);
        IERC20(token1).transferFrom(msg.sender, address(this), amount1);

        reserve0 += amount0;
        reserve1 += amount1;

    }   

    function getAmountOut(uint256 amountIn, address inputToken) public returns(uint256 amountOut){
        require(amountIn > 0, "Invalid input");
        // Suppose:
        // reserve0 = 100 (token0)
        // reserve1 = 100 (token1)
        // amountIn = 10
        // inputToken = token0

        bool isToken0 = inputToken == token0;

        (uint256 reserveIn, uint256 reserveOut) = isToken0 ? (reserve0, reserve1) : (reserve1, reserve0);

        uint256 k = reserveIn * reserveOut;

        uint256 newAmountIn = reserveIn + amountIn;
        uint256 newAmountOut = k / newAmountIn;

        amountOut = reserveOut -  newAmountOut;


        return amountOut;
    }

    function swap(uint amountIn, address inputToken) public {
        bool isToken0 = inputToken == token0;
        
        address outPutToken = isToken0 ? token0 : token1;

        uint256 amountOut = getAmountOut(amountIn, inputToken);

        IERC20(inputToken).transferFrom(msg.sender, address(this), amountIn);
        IERC20(outPutToken).transfer(msg.sender, amountOut);


        if(isToken0){
            reserve0 += amountIn;
            reserve1 -= amountOut;
        }else {
            reserve1 += amountIn;
            reserve0 -= amountOut;
        }
    }
}
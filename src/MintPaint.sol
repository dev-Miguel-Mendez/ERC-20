

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transferFrom(address sender, address to, uint amount) external returns (bool);
    function transfer(address to, uint amount) external returns (bool);
    function balanceOf(address owner) external view returns (uint);
    function approve(address spender, uint amount) external returns (bool);
    function mint(address to, uint amount) external;
}

contract Pair {
    address public token0;
    address public token1;

    uint public reserve0;
    uint public reserve1;

    constructor(address _token0, address _token1) {
        token0 = _token0;
        token1 = _token1;
    }




    // It uses transferFrom() and you need to pass a  "from" to it even if msg.sender is you.⚠️⚠️
    function addLiquidity(uint amount0, uint amount1) external returns (bool) {
                        //⚠️⚠️ WHY NOT USE THIS ⚠️⚠️
        //⚠️⚠️ You couldn't make this work under certain conditions but it's not optimal ⚠️⚠️
        // What if you want to add a liquidity with it WETH?
        // You would need to make another "addLiquidity" function for token/token (like the  one bellow) 
        
        IERC20(token0).transferFrom(msg.sender, address(this), amount0); 
        IERC20(token1).transferFrom(msg.sender, address(this), amount1);  //✨✨ This supposes you already called "<ERC20>.approve(routerAddress, amount)"✨✨
        //✨✨ If you will use ETH (WETH) as tokenX, there is no need to approve, you just give it to UniSwap ✨✨

        reserve0 += amount0;
        reserve1 += amount1;

        return true;
    }

    function getAmountOut(uint amountIn, address inputToken) public view returns (uint256) {
        require(amountIn > 0, "Invalid input");

        // Suppose:
        // reserve0 = 100 (token0)
        // reserve1 = 100 (token1)
        // amountIn = 10
        // inputToken = token0

        bool isToken0 = inputToken == token0; //✨✨ Set input/output reserves based on which token is being input✨✨


        (uint reserveIn, uint reserveOut) = isToken0 ? (reserve0, reserve1) : (reserve1, reserve0);
        //✨✨ When we talk about "reserve out", we're not talking about the amount that gets returned from this function, we just talk about "Token B" but we can't name it something like "token 0", makes sense??? 🤣✨✨


        // newReserveIn = reserveIn + amountIn = 100 + 10 = 110
        uint newReserveIn = reserveIn + amountIn;

        // k = reserveIn * reserveOut = 100 * 100 = 10,000
        uint k = reserveIn * reserveOut;

        // newReserveOut = k / newReserveIn = 10,000 / 110 ≈ 90.909
        uint newReserveOut = k / newReserveIn;

        // amountOut = reserveOut - newReserveOut = 100 - 90.909 ≈ 9.090
        uint256 amountOut = reserveOut - newReserveOut;

        return amountOut;
    }


    function swap(uint amountIn, address inputToken) external {
        bool isToken0 = inputToken == token0;
        address outputToken = isToken0 ? token1 : token0;

        uint amountOut = getAmountOut(amountIn, inputToken);

        //🟠🟠 Provide your tokens 🟠🟠
        //✨✨ This requires prior balance and APPROVAL (normally handled by the Uniswap router but can be done manually)✨✨
        //✨✨ If using the router: you never need to manually hold WETH.✨✨
        //If doing it manually, you need to:
                            // WETH.deposit{value: ...}();
                            // WETH.approve(pairAddress, amount);
                            // pair.swap(...);
        IERC20(inputToken).transferFrom(msg.sender, address(this), amountIn);  //In order to pay WETH, usually: the router automatically convert your ETH into WETH by calling something like IWETH.deposit(...)


        //🟠🟠 Get your tokens 🟠🟠
        //✨✨ "transfer" is used instead of "transferFrom" because "transferFrom" needs permission.✨✨
        //✨✨ "transferFrom would require approval, which makes no sense when this contract is the sender"✨✨
        IERC20(outputToken).transfer(msg.sender, amountOut); //✨✨ ALWAYS when you call this, it will be THIS contract giving you tokens. Below is why.✨✨
                      //✨✨ In the current contract scope✨✨
        //✨✨ msg.sender will be YOUR address as a user
        //✨✨ But in the external contract, msg.sender will be the current address(this)"✨✨ 
        //✨✨ So in the external, tokens will flow from THIS_CONTRACT_ADDRESS -> YOU_AS_USER✨✨ 

        if (isToken0) {
            reserve0 += amountIn;
            reserve1 -= amountOut;
        } else {
            reserve1 += amountIn;
            reserve0 -= amountOut;
        }
    }
}
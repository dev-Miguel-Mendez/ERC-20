// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    //prettier-ignore
    function transferFrom( address sender, address to,uint amount) external returns (bool);

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

    mapping(address => uint) public liquidity0Added;
    mapping(address => uint) public liquidity1Added;

    constructor(address _token0, address _token1) {
        token0 = _token0;
        token1 = _token1;
    }

    event Swap( address indexed sender, address indexed inputToken, address indexed outputToken, uint amountIn, uint amountOut, uint reserveIn, uint reserveOut);

    //⚠️⚠️ Even if you're not using a router, you still need to call approve() TO YOURSELF first, because of addLiquidity() is written.
    // It uses transferFrom() and you need to pass a  "from" to it even if msg.sender is you.⚠️⚠️
    function mint(address provider) external returns (bool) {
        uint balance0 = IERC20(token0).balanceOf(address(this));
        uint balance1 = IERC20(token1).balanceOf(address(this));

        uint added0 = balance0 - reserve0;
        uint added1 = balance1 - reserve1;

        require(added0 > 0 && added1 > 0, "Nothing added");

        reserve0 = uint112(balance0); //This is just mimicking balance0 previous from IERC20(token0).balanceOf(address(this));
        // It helps calculating "added0"
        reserve1 = uint112(balance1); //This is just mimicking balance1 previous from IERC20(token1).balanceOf(address(this));
        // It helps calculating "added1"

        //⚠️⚠️ Normally, here, a mint() function would be called. This whole pair is actually supposed to inherit from an ERC20. This whole pair would be an ERC20 because it needs to provide LP tokens. ⚠️⚠️
        // _mint(to, liquidity);
        //⚠️⚠️ This _mint function is the one that would be inherited and that would refer to the LP tokens of this pair. ⚠️⚠️
        //However, to keep track for now:
        liquidity0Added[provider] = added0;
        liquidity1Added[provider] = added1;

        return true;
    }

    function getAmountOut(
        uint amountIn,
        address inputToken
    ) public view returns (uint) {
        require(amountIn > 0, "Invalid input");

        // Suppose:
        // reserve0 = 100 (token0)
        // reserve1 = 100 (token1)
        // amountIn = 10
        // inputToken = token0

        bool isToken0 = inputToken == token0; //✨✨ Set input/output reserves based on which token is being input✨✨

        (uint reserveIn, uint reserveOut) = isToken0
            ? (reserve0, reserve1)
            : (reserve1, reserve0);
        //✨✨ When we talk about "reserve out", we're not talking about the amount that gets returned from this function, we just talk about "Token B" but we can't name it something like "token 0", makes sense??? 🤣✨✨

        uint newReserveIn = reserveIn + amountIn; // newReserveIn = reserveIn + amountIn = 100 + 10 = 110

        uint k = reserveIn * reserveOut; // k = reserveIn * reserveOut = 100 * 100 = 10,000

        uint newReserveOut = k / newReserveIn; // newReserveOut = k / newReserveIn = 10,000 / 110 ≈ 90.909

        uint amountOut = reserveOut - newReserveOut; // amountOut = reserveOut - newReserveOut = 100 - 90.909 ≈ 9.090

        return amountOut;
    }

    function swap(uint amountIn, address inputToken) external {
        bool isInputToken0 = inputToken == token0;
        address outputToken = isInputToken0 ? token1 : token0;

        uint amountOut = getAmountOut(amountIn, inputToken);

        //🟠🟠 Provide your tokens 🟠🟠
        //✨✨ This requires prior balance and APPROVAL (normally handled by the Uniswap router but can be done manually)✨✨
        //✨✨ If using the router: you never need to manually hold WETH.✨✨
        //If doing it manually, you need to:
        // WETH.deposit{value: ...}();
        // WETH.approve(pairAddress, amount);
        // pair.swap(...);
        IERC20(inputToken).transferFrom(msg.sender, address(this), amountIn); //In order to pay WETH, usually: the router automatically convert your ETH into WETH by calling something like IWETH.deposit(...)

        //🟠🟠 Get your tokens 🟠🟠
        //✨✨ "transfer" is used instead of "transferFrom" because "transferFrom" needs permission.✨✨
        //✨✨ "transferFrom would require approval, which makes no sense when this contract is the sender"✨✨
        IERC20(outputToken).transfer(msg.sender, amountOut); //✨✨ ALWAYS when you call this, it will be THIS contract giving you tokens. Below is why.✨✨
        //✨✨ In the current contract scope✨✨
        //✨✨ msg.sender will be YOUR address as a user
        //✨✨ But in the external contract, msg.sender will be the current address(this)"✨✨
        //✨✨ So in the external, tokens will flow from THIS_CONTRACT_ADDRESS -> YOU_AS_USER✨✨

        if (isInputToken0) {
            reserve0 += amountIn;
            reserve1 -= amountOut;
        } else {
            reserve1 += amountIn;
            reserve0 -= amountOut;
        }
        emit Swap(
            msg.sender,
            inputToken,
            outputToken,
            amountIn,
            amountOut,
            isInputToken0 ? reserve0 : reserve1,
            isInputToken0 ? reserve1 : reserve0
        );
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint amount) external returns (bool);
    function transfer(address recipient, uint amount) external returns (bool);
    function balanceOf(address account) external view returns (uint);
}

contract BasicPair {
    address public token0;
    address public token1;

    uint112 public reserve0; //This is just mimicking balance0 = IERC20(token0).balanceOf(address(this)); 
    uint112 public reserve1; //This is just mimicking balance1 = IERC20(token1).balanceOf(address(this));

    mapping(address => uint) public liquidity0;
    mapping(address => uint) public liquidity1;

    constructor(address _token0, address _token1) {
        token0 = _token0;
        token1 = _token1;
    }

    // function getReserves() public view returns (uint112, uint112) {
    //     return (reserve0, reserve1);
    // }

    // We might prefer using a router to add the liquidity because if not we would need two different mint functions in this contract (one for WETH and one for token/token).
    function mint(address provider) external {
        uint balance0 = IERC20(token0).balanceOf(address(this)); 
        uint balance1 = IERC20(token1).balanceOf(address(this));

        //⚠️⚠️ This below assumes that noOne added tokens in between.⚠️⚠️
        // There is no parallel execution of transactions. The EVM processes transactions sequentially, one after another, in the order the block producer (miner or validator) decides.
        // In a single transaction to the router,the router sends tokens to the pair and calls mint() for Alice at once.
        // So Bob doesn't pollute Alice’s values. It’s serialized. There’s no race condition in EVM.
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
        liquidity0[provider] += added0;
        liquidity1[provider] += added1;

    }


    // function burn(address provider, uint amount0, uint amount1) external {
    //     require(liquidity0[msg.sender] >= amount0, "Not enough token0");
    //     require(liquidity1[msg.sender] >= amount1, "Not enough token1");

    //     liquidity0[provider] -= amount0;
    //     liquidity1[provider] -= amount1;

    //     reserve0 -= uint112(amount0);
    //     reserve1 -= uint112(amount1);

    //     IERC20(token0).transfer(provider, amount0);
    //     IERC20(token1).transfer(provider, amount1);
    // }

    function swap(uint amountIn, address inputToken) external {
        require(amountIn > 0, "Invalid input");

        bool isToken0In = inputToken == token0;
        address outputToken = isToken0In ? token1 : token0;

        IERC20(inputToken).transferFrom(msg.sender, address(this), amountIn);


        uint reserveIn = isToken0In ? reserve0 : reserve1;
        uint reserveOut = isToken0In ? reserve1 : reserve0;

        uint amountInWithFee = amountIn * 997; // optional: fee logic
        uint numerator = amountInWithFee * reserveOut;
        uint denominator = reserveIn * 1000 + amountInWithFee;

        uint amountOut = numerator / denominator;

        require(amountOut < reserveOut, "Insufficient output");

        IERC20(outputToken).transfer(msg.sender, amountOut);

        reserve0 = uint112(IERC20(token0).balanceOf(address(this)));
        reserve1 = uint112(IERC20(token1).balanceOf(address(this)));
    }
}

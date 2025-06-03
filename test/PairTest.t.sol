//SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {DeployPair} from '../script/DeployPair.s.sol';
import {Token} from '../src/Token.sol';
import {Pair} from '../src/Pair.sol';
import {Test, console} from 'forge-std/Test.sol';

contract PairTest is Test{

    Pair pair;
    Token token0;
    Token token1;

    uint amountLiquidity0 = 100 ether; 
    uint amountLiquidity1 = 100 ether; 

    address cyan = makeAddr("cyan");

    function setUp() external {
        //⚠️⚠️ Using the script was giving me issues because it was minting the tokens to the script address. ⚠️⚠️
        // DeployPair deployPair = new DeployPair();
        // (pair, token0, token1) = deployPair.run();

        token0 = new Token('Lily', 'LY', 1000000 ether, 18, msg.sender);
        token1 = new Token('LilEth', 'LE', 1000000 ether, 18, msg.sender);
        pair = new Pair(address(token0), address(token1));

        
        //🟠🟠 Approving 🟠🟠
        vm.prank(msg.sender); //The owner is the one who holds the tokens
        token0.approve(address(pair), amountLiquidity0);

        vm.prank(msg.sender);
        token1.approve(address(pair), amountLiquidity1);
    }

    modifier addLiquidity {
        console.log(msg.sender);

        vm.prank(msg.sender); //Assumes that this wallet also deployed the 2 tokens.
        pair.addLiquidity(amountLiquidity0, amountLiquidity1);
        _;
    }

                                     //⚠️⚠️ Adding liquidity ⚠️⚠️
    function testShouldAddLiquidity() external addLiquidity{
        assertEq(pair.reserve0(), amountLiquidity0);
        assertEq(pair.reserve1(), amountLiquidity1);
    }
                                            //⚠️⚠️ Adding liquidity ⚠️⚠️
    function testShouldCalculateAmountOutToken0() external addLiquidity{ 
        uint256 testAmountIn = 10 ether;
        //⚠️⚠️ Assuming that you are putting 10 token1 in ⚠️⚠️

        uint256 newReserveIn = amountLiquidity1 + testAmountIn;

        uint256 k = amountLiquidity0 * amountLiquidity1;
        uint256 newReserveOut = k / newReserveIn;

        uint256 amountOut = amountLiquidity0 - newReserveOut;

        assertEq(pair.getAmountOut(testAmountIn, address(token1)), amountOut);
    }
                            //⚠️⚠️ Adding liquidity ⚠️⚠️
    function testShouldSwap() external addLiquidity{
        uint256 testInputAmount = 10 ether;
        uint256 amountOut = pair.getAmountOut(testInputAmount, address(token1));

        vm.prank(msg.sender);
        token1.transfer(cyan, testInputAmount);

        
        vm.prank(cyan);
        token1.approve(address(pair), testInputAmount); //🟠🟠 This would occur  outside the pair contract (usually using the router or manually) 🟠🟠

        vm.prank(cyan);
        pair.swap(testInputAmount, address(token1));

        uint256 newPairBalanceToken1 = token1.balanceOf(address(pair));
        assertEq(newPairBalanceToken1, (testInputAmount + amountLiquidity1));

        uint256 newPairBalanceToken0 = token0.balanceOf(address(pair));

        assertEq(newPairBalanceToken0, (amountLiquidity0 - amountOut));


    }
}


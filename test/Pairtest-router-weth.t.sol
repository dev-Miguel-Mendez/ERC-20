//SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {DeployPair} from '../script/DeployPair.s.sol';
import {Token} from '../src/Token.sol';
import {Pair} from '../src/Pair.sol';
import {Test, console} from 'forge-std/Test.sol';
import {Router} from "../src/Router.sol";
import {DeployRouterWeth} from "../script/Deploy-Router-Weth.s.sol";
import {WETH} from '../src/Weth.sol';


contract PairTest is Test{

    Pair pair;
    Token token0;
    WETH wethToken;

    uint amountLiquidity0 = 100 ether; 
    uint amountLiquidity1 = 100 ether; 

    address cyan = makeAddr("cyan");

    Router router;

    function setUp() external {
        DeployRouterWeth deployRouterWeth = new DeployRouterWeth();

        (router, wethToken) = deployRouterWeth.run();
        
        token0 = new Token('Lily', 'LY', 1000000 ether, 18, msg.sender);
        // token1 = new Token('LilEth', 'LE', 1000000 ether, 18, msg.sender);
        pair = new Pair(address(token0), address(wethToken));


        //🟠🟠 Approving 🟠🟠
        vm.prank(msg.sender); //The owner is the one who holds the tokens
        token0.approve(address(router), amountLiquidity0);

    }

    modifier addLiquidity {

        vm.prank(msg.sender); //Assumes that this wallet also deployed the 2 tokens.
        router.addLiquidityEth{value: amountLiquidity1}(address(token0), address(pair), amountLiquidity0);
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

        assertEq(pair.getAmountOut(testAmountIn, address(wethToken)), amountOut);
    }
                            //⚠️⚠️ Adding liquidity ⚠️⚠️
    function testShouldSwapAndGetEth() external addLiquidity{
        uint256 testInputAmount = 10 ether;
        uint256 amountOut = pair.getAmountOut(testInputAmount, address(wethToken));

        console.log(token0.balanceOf(cyan));

        vm.prank(msg.sender);
        token0.transfer(cyan, testInputAmount);

        console.log(token0.balanceOf(cyan));
        vm.prank(cyan);
        token0.approve(address(pair), testInputAmount); //🟠🟠 This would occur  outside the pair contract (usually using the router or manually) 🟠🟠

        vm.prank(cyan);
        pair.swap(testInputAmount, address(token0));

        uint256 pairNewBalancetoken0 = token0.balanceOf(address(pair));
        assertEq(pairNewBalancetoken0, (testInputAmount + amountLiquidity1));



        uint256 pairNewBalanceWETH = wethToken.balanceOf(address(pair));
        assertEq(pairNewBalanceWETH, (amountLiquidity0 - amountOut));


    }

}


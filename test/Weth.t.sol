
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;


import {Test, console} from "forge-std/Test.sol";
import {DeployWeth} from "../script/DeployWeth.s.sol";
import {WETH} from "../src/Weth.sol";


contract WethTest is Test{

    WETH wethToken;

    address lily = makeAddr("lily");
    address cyan = makeAddr("Cyan");
        
    function setUp() external {
        DeployWeth deployToken = new DeployWeth();
        wethToken = deployToken.run();
        vm.deal(lily, 10 ether);
    }


    function testShouldDeposit() external {
        vm.prank(lily);
        wethToken.deposit{value: 5 ether}();

        uint256 balance = wethToken.balanceOf(lily);
        assertEq(balance, 5 ether);
    }

    function testShouldWithdraw() external {
        vm.prank(lily);
        wethToken.deposit{value: 5 ether}();

        uint256 balanceAfterDeposit = wethToken.balanceOf(lily);
        assertEq(balanceAfterDeposit, 5 ether);

        
        vm.prank(lily);
        wethToken.withdraw(5 ether);

        uint256 balanceAfterWithdraw = wethToken.balanceOf(lily);
        assertEq(balanceAfterWithdraw, 0);
    }


    // function testTransferShouldSucceed() external {
    //     vm.prank(msg.sender);
    //     wethToken.transfer(lily, 10);
    //     assertEq(wethToken.balanceOf(lily), 10);
    // }

    // function testApprove() external  {
    //     vm.prank(cyan);
    //     //✨✨ Cyan can approve with having wethTokens✨✨
    //     wethToken.approve(lily, 5);
    //     assertEq(wethToken.allowance(cyan, lily), 5);
    // }

    // function testTransferFrom() external {
    //     //✨✨ Cyan can approve with having wethTokens✨✨
    //     vm.prank(cyan);
    //     wethToken.approve(lily, 5);

    //     //✨✨ However, he needs to have wethTokens for Lily to use "transferFrom()"✨✨
    //     vm.prank(msg.sender);
    //     wethToken.transfer(cyan, 5);

    //     vm.prank(lily);
    //     wethToken.transferFrom(cyan, lily, 5);
    //     assertEq(wethToken.balanceOf(lily), 5);

    // }

}
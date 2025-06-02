
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

        //🟠🟠 Giving Lily initial 5 ETHER 🟠🟠
        vm.prank(lily);
        wethToken.deposit{value: 5 ether}();

    }


    //🟠🟠TESTS SPECIFIC TO WETH 🟠🟠
    function testShouldDeposit() external {

        uint balance = wethToken.balanceOf(lily);
        assertEq(balance, 5 ether);
    }

    function testShouldWithdraw() external {

        uint balanceAfterDeposit = wethToken.balanceOf(lily);
        assertEq(balanceAfterDeposit, 5 ether);

        
        vm.prank(lily);
        wethToken.withdraw(5 ether);

        uint balanceAfterWithdraw = wethToken.balanceOf(lily);
        assertEq(balanceAfterWithdraw, 0);
    }

    
    //🟠🟠TESTS THAT APPLY TO ALL ERC's 🟠🟠
    function testTransferShouldSucceed() external {
        vm.prank(lily);
        wethToken.transfer(cyan, 5 ether);
        assertEq(wethToken.balanceOf(cyan), 5 ether);
    }

    function testApprove() external  {
        vm.prank(cyan);
        //✨✨ Cyan can approve with having wethTokens✨✨
        wethToken.approve(lily, 5 ether);
        assertEq(wethToken.allowance(cyan, lily), 5 ether);
    }

    function testTransferFrom() external {
        vm.prank(lily);
        wethToken.approve(cyan, 5 ether);


        vm.prank(cyan);
        wethToken.transferFrom(lily, cyan, 5 ether);
        assertEq(wethToken.balanceOf(cyan), 5 ether);

    }

}
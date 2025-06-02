
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;


import {Test, console} from "forge-std/Test.sol";
import {DeployToken} from "../script/DeployToken.s.sol";
import {Token} from "../src/Token.sol";


contract TokenTest is Test{

    Token token;

    address lily = makeAddr("lily");
    address cyan = makeAddr("Cyan");
        
    function setUp() external {
        DeployToken deployToken = new DeployToken();
        token = deployToken.run();
    }

    function testOwnerBalance() external view{
        uint256 balance = token.balanceOf(msg.sender);
        // console.log(balance);
        assertEq(balance, token.totalSupply());
    }

    function testTransferShouldSucceed() external {
        vm.prank(msg.sender);
        token.transfer(lily, 10);
        assertEq(token.balanceOf(lily), 10);
    }

    function testApprove() external  {
        vm.prank(cyan);
        //✨✨ Cyan can approve with having tokens✨✨
        token.approve(lily, 5);
        assertEq(token.allowance(cyan, lily), 5);
    }

    function testTransferFrom() external {
        //✨✨ Cyan can approve with having tokens✨✨
        vm.prank(cyan);
        token.approve(lily, 5);

        //✨✨ However, he needs to have tokens for Lily to use "transferFrom()"✨✨
        vm.prank(msg.sender);
        token.transfer(cyan, 5);
        


        vm.prank(lily);
        token.transferFrom(cyan, lily, 5);
        assertEq(token.balanceOf(lily), 5);

    }

}
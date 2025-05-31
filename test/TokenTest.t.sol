
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

    function testOwnerBalance() public view{
        uint256 balance = token.s_balances(msg.sender);
        // console.log(balance);
        assertEq(balance, token.totalSupply());
    }

    function testTransferShouldSucceed() public {
        vm.prank(msg.sender);
        token.transfer(lily, 10);
        assertEq(token.s_balances(lily), 10);
    }

    function testApprove() public  {
        vm.prank(cyan);
        token.approve(lily, 5);

        assertEq(token._allowance(cyan, lily), 5);

    }

}
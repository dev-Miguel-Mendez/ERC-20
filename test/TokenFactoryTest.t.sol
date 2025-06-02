// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.20;

// import "forge-std/Test.sol";
// import {TokenFactory} from "../src/TokenFactory.sol";
// import {Token} from "../src/Token.sol"; // Ensure this path matches your project structure

// contract TokenFactoryTest is Test {
//     TokenFactory factory;

//     function setUp() external {
//         factory = new TokenFactory();
//     }

//     function testCreateToken() external {
//         string memory name = "TestToken";
//         string memory symbol = "TTK";
//         uint256 supply = 1_000_000 ether;
//         uint8 decimals = 18;


//         address tokenAddress = factory.createToken(name, symbol, supply, decimals);
//         assertTrue(tokenAddress != address(0), "Token address should not be zero");

//         Token token = Token(tokenAddress);
//         assertEq(token.name(), name, "Token name mismatch");
//         assertEq(token.symbol(), symbol, "Token symbol mismatch");
//         assertEq(token.totalSupply(), supply, "Total supply mismatch");
//         assertEq(token.balanceOf(address(this)), supply, "Creator balance mismatch");
//     }
// }

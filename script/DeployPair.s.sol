// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.20;


// import {Script} from 'forge-std/Script.sol';

// import {Token} from '../src/Token.sol';
// import {Pair} from '../src/Pair.sol';

// contract DeployPair is Script{
//     function run() external returns(Pair, Token, Token, address) {
//         address creator = msg.sender;

//         vm.startBroadcast();
//         Token token0 = new Token('Lily', 'LY', 1000000 ether, 18, creator);
//         Token token1 = new Token('LilEth', 'LE', 1000000 ether, 18, creator);

//         Pair pair = new Pair(address(token0), address(token1));

//         vm.stopBroadcast();

//         return (pair, token0, token1, creator);
//     }
// }







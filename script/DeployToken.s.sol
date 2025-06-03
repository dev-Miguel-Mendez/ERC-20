//SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;


import {Script} from "forge-std/Script.sol";
import {Token} from "../src/Token.sol";



contract DeployToken is Script {
    function run() external returns(Token){
        vm.startBroadcast();
        Token token = new Token('Lily', 'LY', 1000000 ether, 18, msg.sender);
        vm.stopBroadcast();
        return token;
    }
}
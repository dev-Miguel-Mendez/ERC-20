//SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;


import {Script} from "forge-std/Script.sol";
import {TokenFactory} from "../src/TokenFactory.sol";
import {console} from "forge-std/console.sol"; // <-- just import this


contract DeployToken is Script {
    function run() external {
        vm.startBroadcast();
        new TokenFactory();
        vm.stopBroadcast();
    }
}
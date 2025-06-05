//SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;



import {Script} from "forge-std/Script.sol";
import {PairFactory} from "../src/PairFactory.sol";
import {console} from "forge-std/console.sol"; // <-- just import this


contract DeployToken is Script {
    function run() external {
        vm.startBroadcast();
        new PairFactory();
        vm.stopBroadcast();
    }
}
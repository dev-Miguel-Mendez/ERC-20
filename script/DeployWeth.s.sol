//SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;


import {Script} from "forge-std/Script.sol";
import {WETH} from "../src/Weth.sol";



contract DeployWeth is Script {
    function run() external returns(WETH){
        vm.startBroadcast();
        WETH wethToken = new WETH();
        vm.stopBroadcast();
        return wethToken;
    }
}
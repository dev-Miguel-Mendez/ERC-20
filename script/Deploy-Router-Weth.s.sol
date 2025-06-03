//SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;


import {Script} from "forge-std/Script.sol";
import {WETH} from "../src/Weth.sol";
import {Router} from "../src/Router.sol";



contract DeployRouterWeth is Script {
    function run() external returns(Router, WETH){
        vm.startBroadcast();
        
        WETH wethToken = new WETH();

        Router router = new Router(address(wethToken));

        vm.stopBroadcast();
        return (router, wethToken);
    }
}
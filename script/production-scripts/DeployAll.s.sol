//SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;


import {Script} from "forge-std/Script.sol";
import {WETH} from "../../src/Weth.sol";
import {Router} from "../../src/Router.sol";
import {PairFactory} from "../../src/PairFactory.sol";
import {TokenFactory} from "../../src/TokenFactory.sol";


contract DeployAll is Script {
    function run() external {
        vm.startBroadcast();
        WETH weth = new WETH();
        new Router(address(weth));
        new PairFactory();
        new TokenFactory();
        vm.stopBroadcast();
    }
}
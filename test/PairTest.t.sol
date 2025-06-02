//SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {DeployPair} from '../script/DeployPair.s.sol';

contract Pair {
    function setup() external {
        DeployPair deployPair = new DeployPair();
    }
}
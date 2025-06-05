//SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Pair} from "../src/Pair.sol";

contract PairFactory {

    address[] public allPairs;

    function getAllPairs() public view returns(address[] memory){
        return allPairs;
    }

    event PairCreated(address indexed pair, address token0, address token1);

    function createPair(address token0, address token1) public returns(address){
        Pair pair = new Pair(token0, token1);

        allPairs.push(address(pair));

        emit PairCreated(address(pair)  ,token0, token1); //✨✨ After reviewing, I believe it doesn't matter the order the tokens are passed✨✨

        return address(pair);
    }
}
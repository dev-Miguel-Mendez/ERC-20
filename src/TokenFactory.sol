//SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Token} from "./Token.sol";

contract TokenFactory {
    address[] public allTokens;

    event TokenCreated(address indexed token, string name, string symbol, uint supply, address creator);

    function createToken(string memory name, string memory symbol, uint totalSupply, uint decimals) public returns(address){
        Token token = new Token(name, symbol, totalSupply, decimals);
        allTokens.push(address(token));

        emit TokenCreated(address(token), name, symbol, totalSupply, msg.sender);

        return address(token);
    }

    
    

}
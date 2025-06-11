# Uniswap V2-Style AMM in Solidity

This project is a minimal implementation of a decentralized exchange based on the constant-product AMM model—similar to Uniswap V2. It covers the full flow from token creation to liquidity provisioning and swapping, all written in Solidity 0.8.x.

## Overview

The core component is a contract that manages liquidity for a token pair. It tracks reserves and allows users to add liquidity or perform swaps using the `x·y = k` formula. When swaps happen, it emits events and updates internal balances to maintain equilibrium.

A factory contract lets you create new token pairs on demand. Each pair is deployed as a new contract instance, and the factory keeps track of all pairs created. This pattern makes it easy to scale and index multiple markets.

There's also a router contract that acts as the user-facing interface for adding liquidity, particularly for ETH-token pairs. It handles ETH wrapping behind the scenes using a WETH contract, making the process smoother for users who provide native ETH.

Token creation is supported through a simple ERC-20 token contract and a token factory that lets you deploy new tokens dynamically. This is useful for testing out the AMM with different token setups.

Wrapped ETH is included as a standalone contract to simulate how protocols like Uniswap handle native ETH by wrapping it into an ERC-20–compatible format.

## Main Features

- Basic constant-product AMM logic with reserve tracking  
- Token-to-token and ETH-to-token liquidity provisioning  
- Swap functionality with automatic price adjustment  
- Factory pattern for deploying pairs and tokens  
- Events emitted for pair creation, swaps, and liquidity actions

## Limitations & Future Improvements

- No actual LP token minting—liquidity is tracked internally for now  
- Missing key features like slippage control, swap deadlines, and multi-step routing  
- Security hardening (e.g., reentrancy guards) not yet in place  
- Some functions could be optimized further for gas efficiency


# FIND COMMANDS UNDER foundry.sh and run as "foundry.sh YOUR-COMMAND"

## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**


## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```


### Anvil

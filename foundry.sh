#!/bin/zsh

case $1 in 
    sepolia)
        forge script script/DeployToken.s.sol --rpc-url https://eth-sepolia.g.alchemy.com/v2/uzQLZ3n3vxEs4dqvPUpRjHUNXneDSXcl --keystore ~/.foundry/keystores/sepoliaPK --sender 0x134b5D2Ea08aF086b90044cA8D6bFDC083B7B36e --broadcast --verify --etherscan-api-key 2JMKPHMTAUUTQAVK8SYVJWRVNPK2PXMV1E
        ;;
esac
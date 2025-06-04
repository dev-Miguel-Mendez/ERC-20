#!/bin/zsh

case $1 in

    test)
        echo $@ #* This shows ALL arguments, where "1$" is whatever you call in fsh <>
    ;;
    
    #* SEPOLIA
    token-sepolia)
        forge script script/DeployToken.s.sol --rpc-url https://eth-sepolia.g.alchemy.com/v2/uzQLZ3n3vxEs4dqvPUpRjHUNXneDSXcl --keystore ~/.foundry/keystores/sepoliaPK --sender 0x134b5D2Ea08aF086b90044cA8D6bFDC083B7B36e --broadcast --verify --etherscan-api-key 2JMKPHMTAUUTQAVK8SYVJWRVNPK2PXMV1E 
    ;;

    router-weth-sepolia)
        forge script script/Deploy-Router-Weth.s.sol --rpc-url https://eth-sepolia.g.alchemy.com/v2/uzQLZ3n3vxEs4dqvPUpRjHUNXneDSXcl --keystore ~/.foundry/keystores/sepoliaPK --sender 0x134b5D2Ea08aF086b90044cA8D6bFDC083B7B36e --broadcast --verify --etherscan-api-key 2JMKPHMTAUUTQAVK8SYVJWRVNPK2PXMV1E 
    ;;
    factory-sepolia)
        forge script script/Deploy-TokenFactory.sol --rpc-url https://eth-sepolia.g.alchemy.com/v2/uzQLZ3n3vxEs4dqvPUpRjHUNXneDSXcl --keystore ~/.foundry/keystores/sepoliaPK --sender 0x134b5D2Ea08aF086b90044cA8D6bFDC083B7B36e --broadcast --verify --etherscan-api-key 2JMKPHMTAUUTQAVK8SYVJWRVNPK2PXMV1E 
    ;;



        #* ANVIL
                    #$ That private key is the first one provided by Anvil.
    token-anvil)
        forge script script/DeployToken.s.sol --broadcast --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --rpc-url http://127.0.0.1:8545
    ;;

    router-weth-anvil)
        forge script script/Deploy-Router-Weth.s.sol --rpc-url http://localhost:8545 --broadcast --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 
    ;;

    factory-anvil)
        forge script script/Deploy-TokenFactory.sol --rpc-url http://localhost:8545 --broadcast --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
    ;;



                   #* ANVIL TESTS
    #* Test the router has been deployed with the correct WETH address
    code)
        cast code $2 
    ;;
    weth-addr)
        cast call $2 "WETH_ADDRESS()"
    ;;


    factory-tokens)
        cast call $2 "getTokens()"
    ;;

    token-name)
        cast call $2 "name()"
    ;;

esac
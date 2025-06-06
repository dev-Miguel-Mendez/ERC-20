#!/bin/zsh

case $1 in
    
    #* SEPOLIA


    token-sepolia)
        forge script script/DeployToken.s.sol --rpc-url https://sepolia.infura.io/v3/e1e793f407ec4e19a57e10ab4048a303 --keystore ~/.foundry/keystores/sepoliaPK --sender 0x134b5D2Ea08aF086b90044cA8D6bFDC083B7B36e --broadcast --verify --etherscan-api-key 2JMKPHMTAUUTQAVK8SYVJWRVNPK2PXMV1E 
    ;;


    router-weth-sepolia)
        forge script script/Deploy-Router-Weth.s.sol --rpc-url https://sepolia.infura.io/v3/e1e793f407ec4e19a57e10ab4048a303 --keystore ~/.foundry/keystores/sepoliaPK --sender 0x134b5D2Ea08aF086b90044cA8D6bFDC083B7B36e --broadcast --verify --etherscan-api-key 2JMKPHMTAUUTQAVK8SYVJWRVNPK2PXMV1E 
    ;;
    token-factory-sepolia)
        forge script script/Deploy-TokenFactory.sol --rpc-url https://sepolia.infura.io/v3/e1e793f407ec4e19a57e10ab4048a303 --keystore ~/.foundry/keystores/sepoliaPK --sender 0x134b5D2Ea08aF086b90044cA8D6bFDC083B7B36e --broadcast --verify --etherscan-api-key 2JMKPHMTAUUTQAVK8SYVJWRVNPK2PXMV1E 
    ;;

    pair-factory-sepolia)
        forge script script/Deploy-PairFactory.sol --rpc-url https://sepolia.infura.io/v3/e1e793f407ec4e19a57e10ab4048a303 --keystore ~/.foundry/keystores/sepoliaPK --sender 0x134b5D2Ea08aF086b90044cA8D6bFDC083B7B36e --broadcast --verify --etherscan-api-key 2JMKPHMTAUUTQAVK8SYVJWRVNPK2PXMV1E
    ;;

    # deploy-all-sepolia)
    #     forge script script/production-scripts/DeployAll.s.sol --rpc-url https://sepolia.infura.io/v3/e1e793f407ec4e19a57e10ab4048a303 --keystore ~/.foundry/keystores/sepoliaPK --sender 0x134b5D2Ea08aF086b90044cA8D6bFDC083B7B36e --broadcast --verify --etherscan-api-key 2JMKPHMTAUUTQAVK8SYVJWRVNPK2PXMV1E 
    # ;;


        #* ANVIL
                    #$ That private key is the first one provided by Anvil.

    deploy-all-anvil)
        forge script script/production-scripts/DeployAll.s.sol --rpc-url http://127.0.0.1:8545 --broadcast --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
    ;;

    token-anvil)
        forge script script/DeployToken.s.sol --broadcast --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --rpc-url http://127.0.0.1:8545
    ;;

    router-weth-anvil)
        forge script script/Deploy-Router-Weth.s.sol --rpc-url http://localhost:8545 --broadcast --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 
    ;;

    token-factory-anvil)
        forge script script/Deploy-TokenFactory.sol --rpc-url http://localhost:8545 --broadcast --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
    ;;

    pair-factory-anvil)
        forge script script/Deploy-PairFactory.sol --rpc-url http://localhost:8545 --broadcast --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
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
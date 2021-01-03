# TreeProtocol

eBNB (code name MoneyProtocol) First autonomous price reactive Defi Commodity Money on the Binance Smart Chain with all the characteristics of both GOLD and FIAT.

This repository is a set of contracts in the Binance smartchain.

# The official devnet addresses are:
 BEP-20 Token: [0x9F87799FC95eE8A9c5C858f5b65ca7B6599BA040](https://testnet.bscscan.com/address/0x9F87799FC95eE8A9c5C858f5b65ca7B6599BA040#code).
 
 eBNBpolicy:  [0x6C47abDF3154BFC069769AeB0500cfF1A4E9B69C](https://testnet.bscscan.com/address/0x6C47abDF3154BFC069769AeB0500cfF1A4E9B69C#readProxyContract).
 
 eBNBOrchestrator: [0x03cD60F96B3e57458dCdc4C910EB01086e039BdE](https://testnet.bscscan.com/address/0x03cD60F96B3e57458dCdc4C910EB01086e039BdE#readProxyContract). 

# Table of Contents
  - Install
  - Testing
  - Contribute
  - Licence

# Install:

          npm init -y
          
    # Install Hardhat:  
  
          npm install --save-dev hardhat
          npx hardhat
          npm install --save-dev @nomiclabs/hardhat-ethers ethers
          npm install --save-dev @openzeppelin/hardhat-upgrades

# Testing:
    # You can use the following command to  install testing tool  
           npm install --save-dev chai
           npm install mocha-logger --save-dev
           npm install --save-dev mocha chai
           npm install --save-dev @openzeppelin/test-environment  
           npm install --save-dev @openzeppelin/test-helpers   
           npm install --save-dev @nomiclabs/hardhat-web3 web3    
           npm install --save-dev chai-bignumber                  
           npm install --save-dev @nomiclabs/hardhat-waffle   
           npm install --save-dev @nomiclabs/hardhat-truffle5@nomiclabs/hardhat-web3 web3               
     
    # Run all unit tests
           npx hardhat test
   
# Contribute:
To report bugs within this package, create an issue in this repository.Please contact operations@bosonlabs.net 
100% test coverage is required while submitting any request.	

# License:
GNU General Public License v3.0 (c) 2020 Boson Labs, Inc.


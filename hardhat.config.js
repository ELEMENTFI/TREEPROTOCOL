// hardhat.config.js
const {mnemonic} = require('./secrets.json');

require("@nomiclabs/hardhat-ethers");
require('@openzeppelin/hardhat-upgrades');


/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  
  networks: {
    testnet: {
      url: `https://data-seed-prebsc-1-s1.binance.org:8545`,
      accounts: {mnemonic: mnemonic},
      network_id: 97,
      confirmations: 10,
      timeoutBlocks: 200,
      skipDryRun: true
  }
  },
  solc: {
    version: '0.7.3',
},
};
require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");

require("@nomiclabs/hardhat-ethers");
require('@openzeppelin/hardhat-upgrades');

require('hardhat-contract-sizer');

require('dotenv').config();

const INFURA_API_KEY = process.env.INFURA_API_KEY || "";
const PRIVATE_KEY = process.env.PRIVATE_KEY || "01234567890123456789";
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY || "";


// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      chainId: 3,
      gas: 8000000,
      gasMultiplier: 2,
      allowUnlimitedContractSize: true
    },
    rinkeby: {
      url: `https://rinkeby.infura.io/v3/${INFURA_API_KEY}`,
      gas: 8000000,
      gasMultiplier: 2,
      allowUnlimitedContractSize: true,
      accounts: [PRIVATE_KEY]
    },
    ropsten: {
      url: `https://ropsten.infura.io/v3/${INFURA_API_KEY}`,
      gas: 8000000,
      gasMultiplier: 2,
      allowUnlimitedContractSize: true,
      accounts: [PRIVATE_KEY]
    },
    mumbai: {
      // Infura
      // url: https://polygon-mumbai.infura.io/v3/${INFURA_API_KEY}
      url: "https://rpc-mumbai.matic.today",
      // url: "https://matic-mumbai.chainstacklabs.com/",
      accounts: [PRIVATE_KEY]
    },
    matic: {
      // Infura
      // url: https://polygon-mainnet.infura.io/v3/${INFURA_API_KEY},
      url: "https://rpc-mainnet.maticvigil.com",
      accounts: [PRIVATE_KEY]
    }
  },
  etherscan: {
    apiKey: ETHERSCAN_API_KEY
  },
  solidity: {
    version: "0.8.0",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  }
};
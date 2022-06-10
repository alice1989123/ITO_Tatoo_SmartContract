require("@nomiclabs/hardhat-waffle");
require("hardhat-gas-reporter");
const dotenv = require("dotenv");
dotenv.config();
const gasReport = true;
console.log(process.env.coinMarketCap_API);

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
  solidity: "0.8.4",
  gasReporter: {
    enabled: gasReport, // will give report if REPORT_GAS environment variable is true
    currency: "USD", // can be set to ETH and other currencies (see coinmarketcap api documentation)
    coinmarketcap: process.env.coinMarketCap_API, // to fetch prices from coinmarketcap api
  },
};

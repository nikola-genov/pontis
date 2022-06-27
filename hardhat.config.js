require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
require("solidity-coverage");

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

task("deploy", "Deploys the contract", async (taskArgs, hre) => {
  const phoboCoin = await hre.ethers.getContractFactory("PhoboCoin");
  const phobo = await phoboCoin.deploy();

  await phobo.deployed();

  console.log("PhoboCoin deployed to:", phobo.address);
});

task("deploy-testnets", "Deploys contract on a provided network")
  .setAction(async (taskArguments, hre, runSuper) => {
    const deployBridgeContract = require("./scripts/deploy");
    await deployBridgeContract(taskArguments);
  });

task("deploy-mainnet", "Deploys contract on a provided network")
  .addParam("privateKey", "Please provide the private key")
  .setAction(async ({privateKey}) => {
    const deployElectionContract = require("./scripts/deploy-with-param");
    await deployElectionContract(privateKey);
  });

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: {
    version: "0.8.4",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  networks: {
    rinkeby: {
      url: "https://rinkeby.infura.io/v3/b35c51055583480ba44b8b1c77d83bf9",
      accounts: [
        
      ]
    },
    // ropsten: {

    // }
  },
  etherscan: {
    apiKey: "UZ6NE7US3W1HBWRG1946TRAJ7HW8QWZ8NA"
  }
};
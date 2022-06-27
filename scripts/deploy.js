const hre = require('hardhat')
const ethers = hre.ethers;

async function deployBridgeContract() {
    await hre.run('compile'); // We are compiling the contracts using subtask
    const [deployer] = await ethers.getSigners(); // We are getting the deployer
  
    console.log('Deploying contracts with the account:', deployer.address);
    console.log('Account balance:', (await deployer.getBalance()).toString());

    const PhoboCoin = await hre.ethers.getContractFactory("PhoboCoin");
    const phobo = await PhoboCoin.deploy();
    console.log('Waiting for PhoboCoin deployment...');
    await phobo.deployed();
    console.log("PhoboCoin deployed to:", phobo.address);

    const PontisContract = await hre.ethers.getContractFactory("Pontis");
    const pontis = await PontisContract.deploy();
    console.log('Waiting for Pontis deployment...');
    await pontis.deployed();
    console.log("Pontis deployed to:", pontis.address);

    console.log('Done!');
}
  
module.exports = deployBridgeContract;
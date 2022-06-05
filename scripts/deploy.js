const hre = require('hardhat')
const ethers = hre.ethers;

async function deployElectionContract() {
    await hre.run('compile'); // We are compiling the contracts using subtask
    const [deployer] = await ethers.getSigners(); // We are getting the deployer
  
    console.log('Deploying contracts with the account:', deployer.address); // We are printing the address of the deployer
    console.log('Account balance:', (await deployer.getBalance()).toString()); // We are printing the account balance

    const greeter = await ethers.getContractFactory("Greeter");
    const greeterContract = await greeter.deploy("Hola, amigo");
    console.log('Waiting for Greeter deployment...');
    await greeterContract.deployed();

    console.log('Greeter Contract address: ', greeterContract.address);
    console.log('Done!');
}
  
module.exports = deployElectionContract;
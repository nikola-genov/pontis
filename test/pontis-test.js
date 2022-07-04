const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Pontis", function () {
  let phoboCoin;
  let wrappedPhoboCoin;
  let pontis;
  let owner;
  let jimi;
  let erc20Abi;
  let erc20Signer;

  before(async () => {
    phoboCoinFactory = await ethers.getContractFactory('PhoboCoin');
    phoboCoin = await phoboCoinFactory.deploy();
    await phoboCoin.deployed();

    erc20Abi = phoboCoin.interface;
    erc20Signer = phoboCoin.signer;
    
    const pontisFactory = await ethers.getContractFactory("Pontis");
    pontis = await pontisFactory.deploy();
    await pontis.deployed();
    //await pontis.initRouter();
    
    let accounts = await ethers.getSigners();
    owner = accounts[0];
    jimi = accounts[1];
  });

  it('Should emit Lock event', async () => {
    const amount = 3;
    const fee = ethers.utils.parseEther('0.0000000000000001');
    await phoboCoin.mint(jimi.address, amount * 3);
    await phoboCoin.connect(jimi).approve(pontis.address, amount);

    await expect(pontis.connect(jimi).lock(3, phoboCoin.address, amount, {
      value: fee
    }))
    .to.emit(pontis, 'Lock')
    .withArgs(3, phoboCoin.address, jimi.address, amount, fee);
  });

  it('Should emit Mint and Burn events', async () => {
    const amount = 50;
    const chainId = 4;

    const tx = await pontis.connect(jimi).mint(chainId, phoboCoin.address, amount, jimi.address);
    const receipt = await tx.wait();
    
    let mintEvent = receipt.events.find(e => e.event == 'Mint');
    expect(mintEvent).to.not.be.null;
    expect(mintEvent.args[0]).to.not.be.null;
    expect(mintEvent.args[1]).to.equal(amount);
    expect(mintEvent.args[2]).to.equal(jimi.address);
    
    let wrappedPhobo = mintEvent.args[0];

    const wrappedPhoboContract = new ethers.Contract(wrappedPhobo, erc20Abi, erc20Signer);
    await wrappedPhoboContract.connect(jimi).approve(pontis.address, amount);

    await expect(pontis.connect(jimi).burn(wrappedPhobo, amount, jimi.address))
      .to.emit(pontis, 'Burn')
      .withArgs(wrappedPhobo, amount, jimi.address);
  });
});

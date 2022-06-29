const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Pontis", function () {
  let phoboCoin;
  let wrappedPhoboCoin;
  let pontis;
  let owner;
  let jimi;

  before(async () => {
    phoboCoinFactory = await ethers.getContractFactory('PhoboCoin');
    phoboCoin = await phoboCoinFactory.deploy();
    await phoboCoin.deployed();

    wrappedPhoboCoinFactory = await ethers.getContractFactory('WrappedPhoboCoin');
    wrappedPhoboCoin = await wrappedPhoboCoinFactory.deploy();
    await wrappedPhoboCoin.deployed();

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

    // let allowance = await phoboCoin.allowance(jimi.address, pontis.address);
    // console.log(allowance);

    await expect(pontis.connect(jimi).lock(3, phoboCoin.address, amount, {
      value: fee
    }))
    .to.emit(pontis, 'Lock')
    .withArgs(3, phoboCoin.address, jimi.address, amount, fee);
  });
});

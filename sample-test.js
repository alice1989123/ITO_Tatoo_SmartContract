const { expect } = require("chai");
const { ethers } = require("hardhat");

let Tatoo;
let tatoo;
let owner;
let addr1;
let addr2;
let addrs;

beforeEach(async function () {
  // Get the ContractFactory and Signers here.
  Tatoo = await ethers.getContractFactory("Tatoo");
  tatoo = await Tatoo.deploy();
  [owner, addr1, addr2, ...addrs] = await ethers.getSigners();
  await tatoo.deployed();
});

describe("Contract deploys with correct name and symbol", function () {
  it("Deployment should asing constructor name, symbol, and metadataURL in a correct way", async function () {
    expect(await tatoo.name()).to.equal("Ito_Tatoo_Studio");
    expect(await tatoo.symbol()).to.equal("ITO");
    //console.log(tatoo.functions);
    //console.log(owner);
  });
});
describe("Contract deploys with correct owner and initial supply 0", function () {
  it("Contracts start with 0 tokens and correct owner", async function () {
    expect(await tatoo.totalSupply()).to.equal(0);
    expect(await tatoo.owner()).to.equal(owner.address);
    //console.log(tatoo.functions);
    //console.log(owner);
  });
});

describe("Owner can mint others, can not mint", function () {
  it("Deployment should asing constructor name, symbol, and metadataURL in a correct way", async function () {
    await tatoo.mint(addr1.address, "metadata.1json");
    const minter2 = await tatoo.connect(addr1);

    expect(await tatoo.ownerOf(1)).to.equal(addr1.address);
    expect(minter2.mint(addr1.address, "metadata")).to.be.reverted;
  });
});

describe("Owner can add to whitelist, and after added whilelist members can mint", function () {
  it("Deployment should asing constructor name, symbol, and metadataURL in a correct way", async function () {
    await tatoo.setUser(addr1.address, true);

    const minter2 = await tatoo.connect(addr1);
    await minter2.mint(addr1.address, "metadata");

    expect(await minter2.ownerOf(1)).to.equal(addr1.address);
  });
});

describe("Owner can remove from whitelist", function () {
  it("Deployment should asing constructor name, symbol, and metadataURL in a correct way", async function () {
    await tatoo.setUser(addr1.address, true);

    const minter2 = await tatoo.connect(addr1);
    await minter2.mint(addr1.address, "metadata");

    expect(await minter2.ownerOf(1)).to.equal(addr1.address);
    await tatoo.setUser(addr1.address, false);
    expect(await tatoo.verifyUser(addr1.address)).to.equal(false);
  });
});

describe("Only owner can add to whiteList", function () {
  it("Deployment should asing constructor name, symbol, and metadataURL in a correct way", async function () {
    const minter2 = await tatoo.connect(addr1);
    await expect(minter2.setUser(addr1.address, true)).to.be.reverted;
    await expect(minter2.setUser(addr1.address, false)).to.be.reverted;
  });
});

describe("Contract set ups correct metadata for each token, and we can mint upt to 10000 NFTs", function () {
  it("correct metadata", async function () {
    const metadataURL = "ipfs://QmberSoHPdCTLassDkZzdvE419Ct8W9YoSEupzBuybx";
    for (let i = 1; i < 10000; i++) {
      console.log(i);
      await tatoo.mint(addr1.address, `${metadataURL}${i}/`);
      const tokenId = await tatoo.totalSupply();
      expect(await tatoo.tokenURI(tokenId)).to.equal(
        `${metadataURL}${tokenId}/${tokenId}.json`
      );
    }
  }).timeout(350000);
});

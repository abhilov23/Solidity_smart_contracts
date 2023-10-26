const {expect} = require("chai");
const hre = require("hardhat");

describe("Spacebear", function(){
    async function deployspacebearAndMintTokenFixture(){
        const Spacebear = await hre.ethers.getContractFactory("Spacebear");
        const spacebearInstance = await Spacebear.deploy();
        const [owner, otherAccount] = await ethers.getSigners();
        await spacebearInstance.safeMint(otherAccount.address);
        return {spacebearInstance};
    }


    it("is possible to mint a token", async() => {
        const Spacebear = await hre.ethers.getContractFactory("Spacebear");
        const spacebearInstance = await Spacebear.deploy();
        const [owner, otherAccount] = await ethers.getSigners();
        await spacebearInstance.safeMint(otherAccount.address);
        expect(await spacebearInstance.ownerOd(0)).to.equal(otherAccount.address);
    })
    it("fails to transfer toke from the wrong address", async() => {
        const Spacebear = await hre.ethers.getContractFactory("Spacebear");
        const spacebearInstance = await Spacebear.deploy();
        const [owner, otherAccount] = await ethers.getSigners();
        await spacebearInstance.safeMint(otherAccount.address);

        expect(await spacebearInstance.ownerOd(0)).to.equal(otherAccount.address);
        await expect(spacebearInstance.connect(notTHENFTOwner).transferFrom(otherAccount.address, notTHENFTOwner.address,0)).to.be.revertedWith("ERC721: caller is not token owner");
    })
})
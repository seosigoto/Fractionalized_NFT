
const hre = require("hardhat");
const fs = require('fs');

async function main() {
    const TESTERC721 = await hre.ethers.getContractFactory("MyToken");
    const testserc721 = await TESTERC721.deploy();
    await testserc721.deployed();
    console.log("testserc721 deployed to:", testserc721.address);

    const TESTERC20 = await hre.ethers.getContractFactory("Test20");
    const testserc20 = await TESTERC20.deploy();
    await testserc20.deployed();
    console.log("testserc20 deployed to:", testserc20.address);

    const TESTstaking = await hre.ethers.getContractFactory("FNFT_staking");
    const teststaking = await TESTstaking.deploy(testserc20.address,testserc721.address);
    await teststaking.deployed();
    console.log("staking contract deployed to:", teststaking.address);


    let config = `
    module.exports = {   
        testserc721Address: "${testserc721.address}",
        testserc20Address: "${testserc20.address}",
        teststakingAddress: "${teststaking.address}"     
    }`
    let data = JSON.stringify(config)
    fs.writeFileSync('config.js', JSON.parse(data))
}


main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
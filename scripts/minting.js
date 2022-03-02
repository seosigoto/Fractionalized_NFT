require("dotenv").config()
const NETWORK = process.env.NETWORK
const PRIVATE_KEY = process.env.PRIVATE_KEY
const PUBLIC_KEY = process.env.PUBLIC_KEY
const ethers = require('ethers');

const contract = require("../artifacts/contracts/ERC721.sol/MyToken.json");
const contract20 = require("../artifacts/contracts/ERC20.sol/Test20.json");
const contractstk = require("../artifacts/contracts/FNFT_staking.sol/FNFT_staking.json");

const { testserc721Address, testserc20Address, teststakingAddress } = require('../config');
const nftaddress = testserc721Address;
const provider = ethers.getDefaultProvider(NETWORK);

const wallet = new ethers.Wallet(PRIVATE_KEY, provider);
const nftContract = new ethers.Contract(nftaddress, contract.abi, wallet);

const ftaddress = testserc20Address;
const ftContract = new ethers.Contract(ftaddress, contract20.abi, wallet);

const stkaddress = teststakingAddress;
const stkContract = new ethers.Contract(stkaddress, contractstk.abi, wallet);

let initAmountErc20 = 100;
let value = (initAmountErc20*(10**18)).toString();
var amount = ethers.BigNumber.from(value);

let ownerlist = [ "0xB61868D7DeCD69Ed4F01e237A9F73c779F6053bc",
                "0xE71De43C05115273d76F6b1f4d7fB96Bb0019040",
                "0x24dA7F6D251EFF0363d10dF93aeb3fCFbB2E37B8",
                PUBLIC_KEY];
let valueinit = (100*(10**18)).toString();
var initsupplyamount = ethers.BigNumber.from(valueinit);


const mintNFT = async (tokenURI) => {
    const transaction = await nftContract.safeMint(PUBLIC_KEY);
    const tx = await transaction.wait();
    let tokenId = 3;
    console.log(`${tokenId} ERC721 token minted`)
    await nftContract.setApprovalForAll(stkaddress,true);
    console.log(`ERC721 token Approved`)
    await nftContract["safeTransferFrom(address,address,uint256)"](PUBLIC_KEY,stkaddress,tokenId);
    console.log(`${tokenId} safetransfered`);
}

const mintFT = async (PUBLIC_KEY, amount) => {
    const transaction = await ftContract.grantRole(stkaddress);
    const tx = await transaction.wait();
    console.log(`grant Role to stkcontract`)
}

const initSupply = async (ownerlist, initsupplyamount) => {
    const initsupplyerc20 = await stkContract.InitSupplyERC20(ownerlist, initsupplyamount);
    const inittx = await initsupplyerc20.wait();
    console.log(`grant Role to stkcontract`);
}

async function main () {
    // await mintNFT(PUBLIC_KEY);
    // await mintFT(PUBLIC_KEY, amount);
    await initSupply(ownerlist, initsupplyamount);
}

main()
.then(() => process.exit(0))
.catch((error) => {
    console.error(error);
    process.exit(1);
});
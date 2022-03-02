// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./CustomERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";

contract FNFT_staking is ERC721Holder {
    event daily_Start();
    event Locked();
    event Bid(address indexed sender, uint amount);
    event Withdraw(address indexed bidder, uint amount);
    event mint_and_sent(uint amount);

    // NFT and ERC20 token
    IERC20 public ERC20token;
    IERC721 public ERC721token;
    address auctionContract;

    // percentage per day, 1% fixed
    uint8 public constant dailypercent = 1 ;
    // let us suppose tokenId is only 1; since test project.
    uint public stkedtokenId = 1;
    // total number of ERC20 in contract in condition of tokenID=1 's NFT
    uint public _totalSupply = 0;

    address[] public owners;


    // mint can once in a day
    uint public day_start;
    // staked information; staked ERC token amount: reward Ether amount: tokenId = 1; since test project
    struct stkinfo{
        uint stkedAmount;
        uint rwdAmount;
        uint sttokenId;
    }
    // mapping Address of owner <=> Information
    mapping(address => stkinfo) public userstkinfo;


    constructor(address _ERC20token, address _ERC721token, address _auctionContract) {
        ERC20token = IERC20(_ERC20token);
        ERC721token = IERC721(_ERC721token);
        auctionContract = _auctionContract;

        day_start = block.timestamp;
        emit daily_Start();
    }
    // ownerlist is staked owners list : hardcoded : Due to test project.
    // init supply ERC amount is divided equally. : Dut to test project.
    function stake(address[] memory _ownerlist, uint256 _initSupply) external {
        ERC721token.transferFrom(msg.sender, address(this), stkedtokenId);
        emit Locked();
        uint _average = _initSupply/_ownerlist.length;
        for(uint i = 0; i < _ownerlist.length; i++){
            require(_ownerlist[i] != address(0),"0 address is prohibited");
            stkinfo memory temp;
            temp.rwdAmount = 0;
            temp.stkedAmount = _average;
            temp.sttokenId = stkedtokenId;
            userstkinfo[_ownerlist[i]] = temp;
            owners.push(_ownerlist[i]);
        }
        _totalSupply += _initSupply;
    }

    // View function for check the each info.
    function stkInfo(address _owner, uint256 _tokenId) public view returns (stkinfo memory){
        return(userstkinfo[_owner]);
    }

    // Daily mint ERC20 and directly be sent to auction SC;
    //simply mint and emit : Due to test.
    function dailyMint(uint256 _initSupply, address _auction_address) external{
        require(block.timestamp >= day_start, "not started");
        day_start = block.timestamp + 1 days;

        uint _amount = dailypercent * _initSupply / 100;
        ERC20token.mint(_auction_address, _amount);
        emit mint_and_sent(_amount);


    }


    // After auction, every owner's reward will increase equally (Due to test project)
    // Hardcoded royalty for dev
    // For test, bidincome will not be lower than 0.1 eth; ( I set this condition in only this test)
    function updaterwdAmount() external payable{
        require(address(this) == ERC721token.ownerOf(stkedtokenId), "TokenID Error");
        require(msg.sender == auctionContract, "Auction SC only");

        for(uint i = 0; i < owners.length; i++){
            stkinfo memory temp;
            temp.stkedAmount = userstkinfo[owners[i]].stkedAmount;
            temp.rwdAmount += msg.value * temp.stkedAmount/_totalSupply;
            temp.sttokenId = stkedtokenId;
            userstkinfo[owners[i]] = temp;
        }
    }


    receive() external payable {}
}
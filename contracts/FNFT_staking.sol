// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./CustomERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";


contract FNFT_staking is ERC721Holder {
    IERC20 public ERC20token;
    IERC721 public ERC721token;
    uint8 public constant dailypercent = 1;
    uint public constant initialvoteprice = 0.1 ether;
    uint public constant stkedtokenId = 1;
    address public constant devaddr = 0x0D4ae8efFBCdf74F6005A4a4B6A28B50f36B75f0;
    uint8 public constant devPercent = 5;

    uint public daystart;
    uint public dayend;


    struct stkinfo{
        uint stkedAmount;
        uint rwdAmount;
        uint sttokenId;
    }

    mapping(address => stkinfo) public userstkinfo;

    address public owner;

    constructor(address _ERC20token, address _ERC721token) {
        ERC20token = IERC20(_ERC20token);
        ERC721token = IERC721(_ERC721token);
        stkinfo memory _dev;
        _dev.rwdAmount = 0;
        _dev.stkedAmount = 0;
        _dev.sttokenId = stkedtokenId;
        userstkinfo[devaddr] = _dev;
    }

    function InitSupplyERC20(address[] memory _ownerlist, uint256 _initSupply) public{
        uint _average = _initSupply/_ownerlist.length;
        for(uint i = 0; i < _ownerlist.length-1; i++){
            require(_ownerlist[i] != address(0),"0 address is prohibited");
            stkinfo memory temp;
            temp.rwdAmount = 0;
            temp.stkedAmount = _average;
            temp.sttokenId = stkedtokenId;
            userstkinfo[_ownerlist[i]] = temp;
        }
    }

    function stkInfo(address _owner, uint256 _tokenId) public view returns (stkinfo memory){
        return(userstkinfo[_owner]);
    }

    function dailyMint(uint256 _initSupply) external{
        uint _amount = dailypercent * _initSupply;
        ERC20token.mint(address(this), _amount);
        dayend = block.timestamp + 1 days;
    }

    function updaterwdAmount(uint _tokenId, uint _bidincome, address[] memory _ownerlist) public {
        require(address(this) == ERC721token.ownerOf(_tokenId), "TokenID Error");
        require( _bidincome >= 0.1 ether, "income amount Error");
        userstkinfo[devaddr].rwdAmount = _bidincome/100*devPercent;
        _bidincome -= devPercent/100;
        uint _average = _bidincome/_ownerlist.length;
        for(uint i = 0; i < _ownerlist.length-1; i++){
            require(_ownerlist[i] != address(0),"0 address is prohibited");
            stkinfo memory temp;
            temp.rwdAmount += _average;
            temp.sttokenId = stkedtokenId;
            userstkinfo[_ownerlist[i]] = temp;
        }
    }

    receive() external payable {}

}
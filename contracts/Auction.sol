// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract EnglishAuction {
    event Start();
    event Bid(address indexed sender, uint amount);
    event Withdraw(address indexed bidder, uint amount);
    event End(address winner, uint amount);

    IERC20 public ERC20token;
    uint public amount;

    address payable public seller;
    uint public endAt;
    bool public started;
    bool public ended;

    address public highestBidder;
    uint public highestBid;
    mapping(address => uint) public bids;

    constructor(address _ERC20token, uint _amount) {
        ERC20token = IERC20(_ERC20token);
        seller = payable(msg.sender);
        highestBid = 0.1 ether;
    }

    function start() external {
        require(!started, "started");
        require(msg.sender == seller, "not seller");

        ERC20token.transferFrom(msg.sender, address(this), amount);
        started = true;
        endAt = block.timestamp + 1 days;
        emit Start();
    }

    function bid() external payable {
        require(started, "not started");
        require(block.timestamp < endAt, "ended");
        require(msg.value > highestBid, "value < highest");

        if (highestBidder != address(0)) {
            bids[highestBidder] += highestBid;
        }

        highestBidder = msg.sender;
        highestBid = msg.value;

        emit Bid(msg.sender, msg.value);
    }

    function withdraw() external {
        uint bal = bids[msg.sender];
        bids[msg.sender] = 0;
        payable(msg.sender).transfer(bal);

        emit Withdraw(msg.sender, bal);
    }

    function end() external {
        require(started, "not started");
        require(block.timestamp >= endAt, "not ended");
        require(!ended, "ended");

        ended = true;
        if (highestBidder != address(0)) {
            ERC20token.transferFrom(address(this), highestBidder, amount);
            seller.transfer(highestBid);
        } else {
            ERC20token.transferFrom(address(this), seller, amount);
        }

        emit End(highestBidder, highestBid);
    }
}
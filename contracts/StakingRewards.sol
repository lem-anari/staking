// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "hardhat/console.sol";

contract StakingRewards is Pausable, Ownable, ReentrancyGuard {
    IERC20 myToken;

    // 30 Days (30 * 24 * 60 * 60)
    uint256 public planDuration = 2592000; //2592000

    // 180 Days (180 * 24 * 60 * 60)
    uint256 _planExpired = 15552000;

    uint8 public interestRate = 32; //?
    uint256 public planExpired;
    uint8 public totalStakers;

    struct StakeInfo {
        uint256 startTS;
        uint256 endTS;
        uint256 amount;
        uint256 claimed;
    }

    event Staked(address indexed from, uint256 amount);
    event Claimed(address indexed from, uint256 amount);

    mapping(address => StakeInfo) public stakeInfos;
    mapping(address => bool) public addressStaked;

    constructor(IERC20 _tokenAddress) {
        require(
            address(_tokenAddress) != address(0),
            "Token Address cannot be address 0"
        );
        myToken = _tokenAddress;
        planExpired = block.timestamp + _planExpired; //????
        totalStakers = 0;
    }

    ///???
    function transferToken(address to, uint256 amount) external onlyOwner {
        require(myToken.transfer(to, amount), "Token transfer failed!");
    }

    // msg.sender ?
    function claimReward() external returns (bool) {
        require(
            addressStaked[_msgSender()] == true,
            "You are not participated"
        );
        require(
            stakeInfos[_msgSender()].endTS < block.timestamp,
            "Stake Time is not over yet"
        );
        require(stakeInfos[_msgSender()].claimed == 0, "Already claimed"); //?

        uint256 stakeAmount = stakeInfos[_msgSender()].amount;
        uint256 totalTokens = stakeAmount +
            ((stakeAmount * interestRate) / 100);
        stakeInfos[_msgSender()].claimed == totalTokens;
        myToken.transfer(_msgSender(), totalTokens);

        emit Claimed(_msgSender(), totalTokens);

        return true;
    }

    function getTokenExpiry() external view returns (uint256) {
        require(
            addressStaked[_msgSender()] == true,
            "You are not participated"
        ); //?

        return stakeInfos[_msgSender()].endTS;
    }

    function getTokenAmountStaked() external view returns (uint256) {
        require(
            addressStaked[_msgSender()] == true,
            "You are not participated"
        ); //?

        return stakeInfos[_msgSender()].amount;
    }

    function stakeToken(uint256 stakeAmount) external payable whenNotPaused {
        require(stakeAmount > 0, "Stake amount should be correct");
        require(block.timestamp < planExpired, "Plan Expired");
        console.log(addressStaked[msg.sender]);
        console.log(address(msg.sender));
        require(
            addressStaked[msg.sender] == false,
            "You already participated 1"
        );
        //check approve
        require(
            myToken.balanceOf(_msgSender()) >= stakeAmount,
            "Insufficient Balance"
        );

        myToken.transferFrom(_msgSender(), address(this), stakeAmount);
        totalStakers++;
        addressStaked[_msgSender()] = true;

        stakeInfos[_msgSender()] = StakeInfo({
            startTS: block.timestamp,
            endTS: block.timestamp + planDuration,
            amount: stakeAmount,
            claimed: 0
        });

        emit Staked(_msgSender(), stakeAmount);
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }
}
